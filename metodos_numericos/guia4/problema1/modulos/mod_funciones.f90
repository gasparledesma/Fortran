MODULE funciones
    USE precisiones
    IMPLICIT NONE
    CONTAINS
    
    FUNCTION f(x)
        IMPLICIT NONE
        REAL(pr), INTENT(in)                   :: x
        REAL(pr)                               :: f
    !
        f= x*exp(x)
    !
    END FUNCTION f

    FUNCTION df(x)
        IMPLICIT NONE
        REAL(pr), INTENT(in)                   :: x
        REAL(pr)                               :: df
        !
        df= exp(x)+x*exp(x)
        !
    END FUNCTION df

    FUNCTION g(x)
        implicit none
        real(pr), intent (in)                     :: x
        real(pr)                                  ::g, h

        g= (1/(2*h))*((x+h)*exp(x+h)+(x-h)*exp(x-h))-((h**2)/6)*((x+3)*exp(x))

    end FUNCTION

    FUNCTION E(x)
        implicit none
        real(pr), intent (in)                     :: x
        real(pr)                                  ::E, h

        E= ((h**2)/6)*((x+3)*exp(x))

    end FUNCTION

END MODULE funciones