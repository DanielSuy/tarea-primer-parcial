pkg load database % Cargar el paquete
conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

historialArchivo = 'problema7.txt'; % Nombre del archivo de historial

while true
    fprintf('Menú:\n');
    fprintf('1. Calcular factorial divisible por 7\n');
    fprintf('2. Mostrar historial\n');
    fprintf('3. Salir\n');

    opcion = input('Seleccione una opción: ');

    try
        switch opcion
            case 1
                numero = input('Ingrese un número: ');

                if mod(numero, 7) == 0
                    factorial = 1;
                    for i = 1:numero
                        factorial = factorial * i;
                    end
                    fprintf('El factorial de %d es %d.\n', numero, factorial);
                    insert_query = sprintf("INSERT INTO Factor7 VALUES (%d, 'El factorial es %d')", numero, factorial);
                else
                    fprintf('El número %d no es divisible entre 7.\n', numero);
                    insert_query = sprintf("INSERT INTO Factor7 VALUES (%d, 'El numero %d no es divisible entre 7')", numero, numero);
                end

                pq_exec_params(conn, insert_query);

            case 2
                result_query = 'SELECT * FROM Factor7;';
                result = pq_exec_params(conn, result_query);

                if isempty(result.data)
                    fprintf('El historial está vacío.\n');
                else
                    historial = result.data(:, 2);
                    disp(historial);

                    % Guardar historial en un archivo de texto
                    fid = fopen(historialArchivo, 'w');
                    fprintf(fid, '%s\n', historial{:});
                    fclose(fid);
                end

            case 3
                fprintf('Saliendo del programa.\n');
                pq_close(conn);
                break;

            otherwise
                fprintf('Opción no válida. Por favor, seleccione una opción válida.\n');
        end
    catch exception
        fprintf('Error: %s\n', exception.message);
    end
end


