pkg load database % Cargar el paquete
conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

while true
    % Menú
    fprintf('1. Ingresar año y determinar si es bisiesto\n');
    fprintf('2. Mostrar historial\n');
    fprintf('3. Salir\n');

    opcion = input('Ingrese su opción: ');

    switch opcion
        case 1
            % Ingresar año y determinar si es bisiesto
            numero = input('Ingrese el año: ');

            if rem(numero, 4) == 0 && (rem(numero, 100) ~= 0 || rem(numero, 400) == 0)
                fprintf('%d es un año bisiesto.\n', numero);
                estado = 'El año es bisiesto';
            else
                fprintf('%d no es un año bisiesto.\n', numero);
                estado = 'No es año bisiesto';
            end

            % Guardar en la base de datos
            insert_query = sprintf("INSERT INTO problema114 VALUES (%d, '%s')", numero, estado);
            pq_exec_params(conn, insert_query);

            % Guardar en el archivo de texto
            fileID = fopen('problema114.txt', 'a');
            fprintf(fileID, 'Año: %d, Estado: %s\n', numero, estado);
            fclose(fileID);

        case 2


            % Mostrar historial desde el archivo de texto
            try
                fileID = fopen('problema114.txt', 'r');
                if fileID == -1
                    error('No se pudo abrir el archivo problema114.txt');
                end

                fprintf('\nHistorial desde el archivo de texto:\n');
                while ~feof(fileID)
                    line = fgetl(fileID);
                    disp(line);
                end

                fclose(fileID);

            catch exception
                fprintf('Error al leer el archivo problema114.txt: %s\n', exception.message);
            end

        case 3
            % Salir del programa
            fprintf('Saliendo del programa.\n');
            pq_close(conn);
            break;

        otherwise
            fprintf('Opción no válida. Por favor, ingrese una opción válida.\n');
    end
end

