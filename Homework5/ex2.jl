using Plots
using Interact
using Mux, WebIO

function deriv(f, a, h=0.001)
    (f(a + h) - f(a)) / h
end

# 2

function tangent_line(f, a)
    dfdx = deriv(f, a)
    c = f(a) - dfdx * a
    tangent(x) = dfdx * x .+ c
    return tangent
end

# 3

f(x) = x^3 - 2*x
function app(req)
    a = Array(-10.0:0.5:10.0)
    @manipulate for x in -10:0.5:10
        plot(a, f.(a), label="f(x)")
        tangent = tangent_line(f, x)
        plot!(a, tangent.(a), label="f'(x)")        
    end
end
webio_serve(page("/", app), 8000)

# 4 
function ∂x(f, a, b)
    deriv(x -> f(x, b), a)
end

function ∂y(f, a, b)
    deriv(x -> f(a, x), b)
end

# 5 
function gradient(f, a, b)
    (∂x(f, a, b), ∂y(f, a, b))
end


