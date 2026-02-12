MODULE interpolacion
USE precisiones
USE funciones
IMPLICIT NONE
CONTAINS

SUBROUTINE lagrange(n,x0,y0,x,y)
implicit none
INTEGER, INTENT(in)                    :: n
REAL(pr), DIMENSION(0:n), INTENT(in)   :: x0,y0
REAL(pr), INTENT(in)                   :: x
REAL(pr), INTENT(out)                  :: y
REAL(pr)                               :: p
INTEGER                                :: k,j

y=0.0
DO k=0,n

   p=1.0
   
   DO j=0,n
   
      if(j /= k) p = p*(x-x0(j))/(x0(k)-x0(j))
      
   ENDDO
   
   y = y + p*y0(k)
   
ENDDO
END SUBROUTINE lagrange

SUBROUTINE newton(n,x0,y0,x,y) 
INTEGER, INTENT(IN)                    :: n
REAL(pr),DIMENSION(0:n), INTENT(IN)    :: x0,y0
REAL(pr),INTENT(IN)                    :: x
REAL(pr),INTENT(OUT)                   :: y
REAL(pr),DIMENSION(0:n)                :: a                   
INTEGER                                :: i,j

DO  i = 0,n

   a(i) = y0(i) 
   
END DO

DO  j = 1,n

   DO  i = n,j,-1   
   
      a(i) = (a(i) - a(i-1))/(x0(i) - x0(i-j))
      
   END DO
   
END DO

!!write(*,*)"evaluo el polinomio"

y = a(n) 
DO  i=n-1,0,-1 

   y = y*(x - x0(i)) + a(i) 
   
END DO

END SUBROUTINE newton

SUBROUTINE newton1(n,x0,y0,x,y) 
INTEGER, INTENT(IN)                    :: n
REAL(pr),DIMENSION(0:n), INTENT(IN)    :: x0,y0
REAL(pr),INTENT(IN)                    :: x
REAL(pr),INTENT(OUT)                   :: y
REAL(pr),DIMENSION(0:n)                :: a                   
REAL(pr),DIMENSION(0:n,0:n)            :: d                   
INTEGER                                :: i,j



d=0.0_pr
DO i=0,n
  d(i,0)=y0(i)
END DO
DO j=1,n
  DO i=n,j,-1
    d(i,j) = (d(i,j-1)-d(i-1,j-1))/(x0(i)-x0(i-j))
  END DO
END DO

DO i=0,n
  WRITE(*,100)(d(i,j),j=0,n)
END DO

100 FORMAT(7(x,F10.7)) 
   
DO  j = 1,n
   DO  i = n,j,-1   
      a(i) = (a(i) - a(i-1))/(x0(i) - x0(i-j))
   END DO
END DO
    
!    evalúo el polinomio

y = d(n,n) 
DO  i=n-1,0,-1 
   y = d(i,i) + (x - x0(i))*y
END DO

END SUBROUTINE newton1
END MODULE interpolacion
