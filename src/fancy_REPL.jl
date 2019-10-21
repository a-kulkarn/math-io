

export @m2

### Yarrrr! I be a type pirate! ####
import Base.show
function show(io::IO, x::Hecke.AbstractAlgebra.Generic.PolynomialElem)
    
   len = length(x)
   S = var(parent(x))
   if len == 0
      print(IOContext(io, :compact => true), base_ring(x)(0))
   else
      for i = 1:len - 1
         c = coeff(x, len - i)
         bracket = needs_parentheses(c)
         if !iszero(c)
            if i != 1 && !displayed_with_minus_in_front(c)
               print(io, "+")
            end
            if !isone(c) && (c != -1 || show_minus_one(typeof(c)))
               if bracket
                  print(io, "(")
               end
               print(IOContext(io, :compact => true), c)
               if bracket
                  print(io, ")")
               end
               print(io, "*")
            end
            if c == -1 && !show_minus_one(typeof(c))
               print(io, "-")
            end
            # Probably better to define a "print variable" function to hook into here.
            print(io, Crayon(foreground=:cyan,bold=true), string(S))
            if len - i != 1
               print(io, "^")
               print(io, len - i)
            end
            print(io,  Crayon(reset=true))
         end
      end
      c = coeff(x, 0)
      bracket = needs_parentheses(c)
      if !iszero(c)
         if len != 1 && !displayed_with_minus_in_front(c)
            print(io, "+")
         end
         if bracket
            print(io, "(")
         end
         print(IOContext(io, :compact => true), c)
         if bracket
            print(io, ")")
         end
      end
   end
end

# Actually have a unified interface.
import Hecke.Generic.coeffs
coeffs(f::PolyElem) = coefficients(f)


# Friendly syntax for input.
# Macaulay2 style syntax for polynomial rings.
macro m2(n)
    if typeof(n) == Expr
        #println(n.args)
        args = n.args

        # The assignment identifier.
        R = args[1]
        args = args[2].args

	#println(args)

        if args[1] == :QQ && length(args) == 2
            ve1    = args[2]
            varstr = string(ve1)
            return esc(:(($R,$ve1)=PolynomialRing(FlintQQ,$varstr)))            
        end

        #check if the symbol is defined and not a data type.        
        if typeof(:($args[1])) <: DataType
            error("Array from type not admissible in @m2 macro")
        end

        bring  = args[1]
        ve1    = args[2]
        varstr = string(ve1)
        return esc(:(($R,$ve1)=PolynomialRing($bring,$varstr)))            
    end
error("bad input to macro.")
end

