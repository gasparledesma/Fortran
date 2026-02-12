module funciones

use isoprec

contains

!-----------------------------------------------------------------------------------------

function delta(t)
    implicit none
    real(kind=wp) , intent(in) :: t , 
    real(kind=wp)              :: delta, epsilon_0
    delta = (t-epsilon_0)/2
end function

!-----------------------------------------------------------------------------------------

function gamma(t)
    implicit none
    real(kind=wp) , intent(in) :: t
    real(kind=wp)              :: gamma, V_x , epsilon_0
    gamma = sqrt(V_x**2-((t-epsilon_0)/2))
end function

!-----------------------------------------------------------------------------------------

function sigma1(t)
    implicit none
    real(kind=wp) , intent(in) :: t
    real(kind=wp)              :: sigma1
    sigma1 = delta(t)-i*gamma(t)
end function


function sigma_pos(t)
    implicit none
    real(kind=wp) , intent(in) :: t
    real(kind=wp)              :: sigma_pos, V_x , epsilon_0
    sigma_pos = (t-epsilon_0)/2 + sqrt(V_x**2-((t-epsilon_0)/2))
end function

function sigma_neg(t)
    implicit none
    real(kind=wp) , intent(in) :: t
    real(kind=wp)              :: sigma_neg, V_x , epsilon_0
    sigma_neg = (t-epsilon_0)/2 - sqrt(V_x**2-((t-epsilon_0)/2))
end function

end module funciones