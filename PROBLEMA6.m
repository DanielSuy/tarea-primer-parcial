% Cargar el paquete de base de datos
pkg load database

try
    % Conectar a la base de datos
    conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

    historial = [];  % Inicializar el historial para almacenar resultados

    while true
        fprintf("\nOpciones:\n");
        fprintf("1. Determinar tipo de triángulo\n");
        fprintf("2. Mostrar historial\n");
        fprintf("3. Salir\n");

        opcion = input("Seleccione una opción (1-3): ");

        if opcion == 3
            break;
        end

        if opcion < 1 || opcion > 3
            fprintf("Opción no válida. Por favor, elija una opción válida.\n");
            continue;
        end

        switch opcion
            case 1
                % Pedir al usuario que ingrese los tres lados del triángulo
                lado1 = input("Ingrese el primer lado del triángulo: ");
                lado2 = input("Ingrese el segundo lado del triángulo: ");
                lado3 = input("Ingrese el tercer lado del triángulo: ");

                % Verificar las condiciones para determinar el tipo de triángulo
                if lado1 == lado2 && lado2 == lado3
                    tipo = "Equilátero";
                elseif lado1 == lado2 || lado1 == lado3 || lado2 == lado3
                    tipo = "Isósceles";
                else
                    tipo = "Escaleno";
                end

                historial = [historial; struct("Lado1", lado1, "Lado2", lado2, "Lado3", lado3, "Tipo", tipo)];

                fprintf("El triángulo con lados %d, %d y %d es %s.\n", lado1, lado2, lado3, tipo);

                % Insertar en la base de datos
                query = sprintf("INSERT INTO problema6 (lado1, lado2, lado3, triangulo) VALUES ('%d', '%d', '%d', '%s');", lado1, lado2, lado3, tipo);
                N = pq_exec_params(conn, query);

            case 2
                fprintf("\nHistorial de cálculos:\n");
                for i = 1:length(historial)
                    fprintf("Lados: %d, %d, %d - Tipo: %s\n", historial(i).Lado1, historial(i).Lado2, historial(i).Lado3, historial(i).Tipo);
                end
        end

        % Generar y actualizar un archivo de texto
        fid = fopen('problema6.txt', 'a'); % Abrir el archivo en modo de anexar (append)
        fprintf(fid, 'Opción: %d\n', opcion);

        if opcion == 1
            fprintf(fid, 'Intento registrado con éxito. Triángulo: %s\n', tipo);
        elseif opcion == 2
            fprintf(fid, 'Historial de cálculos:\n');
            for i = 1:length(historial)
                fprintf(fid, 'Lados: %d, %d, %d - Tipo: %s\n', historial(i).Lado1, historial(i).Lado2, historial(i).Lado3, historial(i).Tipo);
            end
        end

        fprintf(fid, '----------------------------------------\n');
        fclose(fid);
    end

    % Cerrar la conexión a la base de datos
    pq_close(conn);
catch
    disp("Error al conectar a la base de datos o al procesar la información.");
end


