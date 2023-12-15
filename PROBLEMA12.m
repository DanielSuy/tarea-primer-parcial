pkg load database % Cargar el paquete
conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

% Inicializar el historial
historial = {};

try
    while true
        % Mostrar el menú
        fprintf('1. Calcular área del círculo\n');
        fprintf('2. Calcular área del rectángulo\n');
        fprintf('3. Calcular área del triángulo\n');
        fprintf('4. Calcular área del cuadrado\n');
        fprintf('5. Mostrar historial\n');
        fprintf('6. Salir\n');

        % Solicitar la opción al usuario
        opcion = input('Seleccione una opción: ');
        figura = "";
        area = NaN;  % Inicializar el área como NaN para manejar casos donde no se calcula el área

        try
            if opcion == 1
                % Calcular área del círculo
                radio = input('Ingrese el radio del círculo: ');
                area = pi * radio^2;
                historial{end+1} = sprintf('Área del círculo (radio %.2f): %.2f', radio, area);
                fprintf('El área del círculo es: %.2f\n', area);
                figura = "circulo";
            elseif opcion == 2
                % Calcular área del rectángulo
                base = input('Ingrese la base del rectángulo: ');
                altura = input('Ingrese la altura del rectángulo: ');
                area = base * altura;
                historial{end+1} = sprintf('Área del rectángulo (base %.2f, altura %.2f): %.2f', base, altura, area);
                fprintf('El área del rectángulo es: %.2f\n', area);
                figura = "rectangulo";
            elseif opcion == 3
                % Calcular área del triángulo
                base = input('Ingrese la base del triángulo: ');
                altura = input('Ingrese la altura del triángulo: ');
                area = 0.5 * base * altura;
                historial{end+1} = sprintf('Área del triángulo (base %.2f, altura %.2f): %.2f', base, altura, area);
                fprintf('El área del triángulo es: %.2f\n', area);
                figura = "triangulo";
            elseif opcion == 4
                % Calcular área del cuadrado
                lado = input('Ingrese el lado del cuadrado: ');
                area = lado^2;
                historial{end+1} = sprintf('Área del cuadrado (lado %.2f): %.2f', lado, area);
                fprintf('El área del cuadrado es: %.2f\n', area);
                figura = "cuadrado";
            elseif opcion == 5
                % Mostrar historial
                fprintf('Historial:\n');
                for i = 1:length(historial)
                    fprintf('%s\n', historial{i});
                end
            elseif opcion == 6
                % Salir del programa
                fprintf('Saliendo del programa.\n');
                break;
            else
                fprintf('Opción no válida. Por favor seleccione una opción válida.\n');
            end

            % Insertar en la base de datos
            query = sprintf("INSERT INTO problema12 (area, figura) VALUES ('%0.2f', '%s');",  ...
                             area, figura);
            N = pq_exec_params(conn, query);

            % Escribir en el archivo de texto
            try
                fid = fopen('problema12.txt', 'a'); % Cambio 'w' a 'a' para modo de adición
                fprintf(fid, 'Área: %.2f\n', area);
                fprintf(fid, 'Figura: %s\n', figura);
                fclose(fid);
                fprintf("Datos guardados en 'problema12.txt'.\n");
            catch exception
                fprintf("Error al guardar en el archivo: %s\n", exception.message);
            end

        catch exception
            fprintf("Error al calcular el área: %s\n", exception.message);
        end
    end
catch exception
    fprintf("Error general: %s\n", exception.message);
end



