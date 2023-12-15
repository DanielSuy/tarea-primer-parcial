pkg load database % Cargar el paquete
conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

while true
    % Menú
    fprintf('1. Ingresar modelo y kilómetros\n');
    fprintf('2. Mostrar historial\n');
    fprintf('3. Salir\n');

    opcion = input('Ingrese su opción: ');

    switch opcion
        case 1
            % Ingresar modelo y kilómetros
            modelo = input('Ingrese el modelo del taxi: ');
            kilometraje = input('Ingrese los kilómetros recorridos: ');

            % Evaluar el estado del taxi
            if modelo < 2007 && kilometraje > 20000
                estado = 'El taxi debe renovarse';
            elseif modelo >= 2007 && modelo <= 2013 && kilometraje >= 20000
                estado = 'El taxi necesita mantenimiento';
            elseif modelo > 2013 && kilometraje < 10000
                estado = 'El taxi está en óptimas condiciones';
            else
                estado = 'El taxi necesita atención mecánica';
            end

            % Mostrar el resultado
            fprintf('%s\n', estado);

            % Guardar en la base de datos
            insert_query = sprintf("INSERT INTO problema811 VALUES (%d,%d, '%s')", modelo, kilometraje, estado);
            pq_exec_params(conn, insert_query);

            % Guardar en un archivo de texto
            fileID = fopen('problema811.txt', 'a');
            fprintf(fileID, 'Modelo: %d, Kilometraje: %d, Estado: %s\n', modelo, kilometraje, estado);
            fclose(fileID);

        case 2
        fileID = fopen('problema811.txt', 'r');
        if fileID == -1
            error('No se pudo abrir el archivo historial.txt');
        end

        fprintf('\nHistorial desde el archivo de texto:\n');
        while ~feof(fileID)
            line = fgetl(fileID);
            disp(line);
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

