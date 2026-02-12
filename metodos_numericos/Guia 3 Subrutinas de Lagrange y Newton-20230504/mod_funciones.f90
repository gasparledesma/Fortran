MODULE funciones
USE precisiones
IMPLICIT NONE
CONTAINS

FUNCTION f(x)
IMPLICIT NONE
REAL(pr), INTENT(in)                   :: x
REAL(pr)                               :: f
!
f=COS(x)
!
END FUNCTION f
END MODULE funciones
