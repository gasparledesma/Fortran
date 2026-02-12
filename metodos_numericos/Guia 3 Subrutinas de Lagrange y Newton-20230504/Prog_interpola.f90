PROGRAM problema4
!
USE precisiones
USE funciones
USE interpolacion
!
IMPLICIT NONE
!
INTEGER,PARAMETER                   :: n = 2
REAL(pr),ALLOCATABLE                :: x(:),y(:)
REAL(pr)                            :: z,fz,dz,error
!REAL(pr)                            :: z1,fz1,dz1,error1
INTEGER                             :: i
INTEGER                             :: Nptos=50
!

ALLOCATE(x(0:n))
ALLOCATE(y(0:n))

x=(/0._pr,0.6_pr,1.0_pr/)
y(0)=cos(x(0))
y(1)=cos(x(1))
y(2)=cos(x(2))

!x=(/1._pr,1.3_pr,1.6_pr,1.9_pr,2.2_pr /)
!y(0)=0.7651977
!y(1)=0.6200860
!y(2)=0.4554022
!y(3)=0.2818186
!y(4)=0.1103623

OPEN(UNIT=10,FILE="lagrange.dat")
OPEN(UNIT=11,FILE="newton.dat")
OPEN(UNIT=12,FILE="newton1.dat")

z=x(0)

dz=(x(n)-x(0))/Nptos

!DO WHILE (z.le.x(n))

DO i=0,Nptos
   z = x(0) + i*dz
   CALL lagrange(n,x,y,z,fz)
   error=ABS(fz-f(z))
   WRITE(10,100)z,fz,f(z),error
   CALL newton(n,x,y,z,fz)
   error=ABS(fz-f(z))
   WRITE(11,100)z,fz,f(z),error
   CALL newton1(n,x,y,z,fz)
   error=ABS(fz-f(z))
   WRITE(12,100)z,fz,f(z),error
ENDDO

100 FORMAT(4(E13.7,1x))

WRITE(*,*)'LISTO'

CLOSE(10)
CLOSE(11)
CLOSE(12)
DEALLOCATE(x)
DEALLOCATE(y)
!
END PROGRAM problema4
