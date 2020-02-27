> lm(y~x)
Error in eval(predvars, data, env) : 객체 'y'를 찾을 수 없습니다
> traceback() # these means seven level error. 
7: eval(predvars, data, env)
6: eval(predvars, data, env)
5: model.frame.default(formula = y ~ x, drop.unused.levels = TRUE)
4: stats::model.frame(formula = y ~ x, drop.unused.levels = TRUE)
3: eval(mf, parent.frame())
2: eval(mf, parent.frame())
1: lm(y ~ x)
> debug(lm)
> lm(y~x)
debugging in: lm(y ~ x)
debug: {
        ret.x <- x
        ret.y <- y
        cl <- match.call()
        mf <- match.call(expand.dots = FALSE)
        m <- match(c("formula", "data", "subset", 
                     "weights", "na.action", "offset"), 
                   names(mf), 0L)
        mf <- mf[c(1L, m)]
        mf$drop.unused.levels <- TRUE
        mf[[1L]] <- quote(stats::model.frame)
        mf <- eval(mf, parent.frame())
        if (method == "model.frame") 
                return(mf)
        else if (method != "qr") 
                warning(gettextf("method = '%s' is not supported. Using 'qr'", 
                                 method), domain = NA)
        mt <- attr(mf, "terms")
        y <- model.response(mf, "numeric")
        w <- as.vector(model.weights(mf))
        if (!is.null(w) && !is.numeric(w)) 
                stop("'weights' must be a numeric vector")
        offset <- model.offset(mf)
        mlm <- is.matrix(y)
        ny <- if (mlm) 
                nrow(y)
        else length(y)
        if (!is.null(offset)) {
                if (!mlm) 
                        offset <- as.vector(offset)
                if (NROW(offset) != ny) 
                        stop(gettextf("number of offsets is %d, should equal %d (number of observations)", 
                                      NROW(offset), ny), domain = NA)
        }
        if (is.empty.model(mt)) {
                x <- NULL
                z <- list(coefficients = if (mlm) matrix(NA_real_, 0, 
                                                         ncol(y)) else numeric(), residuals = y, fitted.values = 0 * 
                                  y, weights = w, rank = 0L, df.residual = if (!is.null(w)) sum(w != 
                                                                                                        0) else ny)
                if (!is.null(offset)) {
                        z$fitted.values <- offset
                        z$residuals <- y - offset
                }
        }
        else {
                x <- model.matrix(mt, mf, contrasts)
                z <- if (is.null(w)) 
                        lm.fit(x, y, offset = offset, singular.ok = singular.ok, 
                               ...)
                else lm.wfit(x, y, w, offset = offset, singular.ok = singular.ok, 
                             ...)
        }
        class(z) <- c(if (mlm) "mlm", "lm")
        z$na.action <- attr(mf, "na.action")
        z$offset <- offset
        z$contrasts <- attr(x, "contrasts")
        z$xlevels <- .getXlevels(mt, mf)
        z$call <- cl
        z$terms <- mt
        if (model) 
                z$model <- mf
        if (ret.x) 
                z$x <- x
        if (ret.y) 
                z$y <- y
        if (!qr) 
                z$qr <- NULL
        z
}
Browse[2]>n # 'n' means next level of error, keep typing debugging is over.

> options(error=recover) # change default R error behavior
> read.csv("nosuchfile")
Error in file(file, "rt") : 커넥션을 열 수 없습니다
추가정보: 경고메시지(들): 
In file(file, "rt") :
        파일 'nosuchfile'를 여는데 실패했습니다: No such file or directory

Enter a frame number, or 0 to exit   

1: read.csv("nosuchfile")
2: read.table(file = file, header = header, sep = sep, quote = quote, dec = dec, fi
3:file(file, "rt")

select:
 # recover() : can select sort of function and debugging each selection.
