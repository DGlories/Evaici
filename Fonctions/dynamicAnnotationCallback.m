function dynamicAnnotationCallback(src,event,Torque,movementIndex)
% keyboard
global matr
% disp('Button clicked!');   

selectedMovement = str2double(src.String);

for p = 1:length(matr)
            if p == selectedMovement
            matr(p).Color(4) = 1.0; % Opacit� de 100% pour la courbe s�lectionn�e
            else
            matr(p).Color(4) = 0.1; % Opacit� de 10% pour les autres courbes
            end
        end
            
end



