function PROBLEMA140()
    % Establecer conexión a PostgreSQL
    conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

    historial = [];

    while true
        disp("1. Verificar año bisiesto");
        disp("2. Mostrar historial");
        disp("3. Salir");

        % Solicitar al usuario que ingrese una opción válida
        opcion = input("Ingrese la opción deseada: ");
        while ~ismember(opcion, [1, 2, 3])
            disp("Opción no válida. Intente de nuevo.");
            opcion = input("Ingrese la opción deseada: ");
        end

        switch opcion
            case 1
                try
                    year = input("Ingrese el año de nacimiento: ");
                    % Verificar si el año ingresado es un número entero positivo
                    if isnumeric(year) && isscalar(year) && year >= 0 && mod(year, 1) == 0
                        esBisiesto = mod(year, 4) == 0 && (mod(year, 100) ~= 0 || mod(year, 400) == 0);
                        fprintf("El año %d %s bisiesto.\n", year, ternary(esBisiesto, 'es', 'no es'));
                        historial = [historial; year, esBisiesto];

                        % Crear la instrucción SQL para insertar en la tabla 'problema140'
                        Instruccion = sprintf("insert into problema140 (anio, es_bisiesto) values (%d, %d);", year, esBisiesto);

                        % Ejecutar la instrucción SQL para registrar el intento
                        exec(conn, Instruccion);

                        % Guardar en el archivo de texto
                        guardarEnTexto(year, esBisiesto);
                    else
                        disp("Entrada no válida. Asegúrese de ingresar un año válido.");
                    end
                catch
                    % Ignorar errores de conversión y otros posibles errores
                end

            case 2
                if isempty(historial)
                    disp("Historial vacío.");
                else
                    disp("Historial:");
                    disp(historial);
                end

            case 3
                disp("Saliendo del programa.");
                close(conn);
                break;

            otherwise
                disp("Opción no válida. Intente de nuevo.");
        end
    end
end

function guardarEnTexto(year, esBisiesto)
    nombreArchivo = 'problema140.txt';

    try
        % Verificar si el archivo existe
        if exist(nombreArchivo, 'file') ~= 2
            % Si no existe, crear el archivo
            fid = fopen(nombreArchivo, 'w');
            fprintf(fid, 'Año\tEs Bisiesto\n');
            fclose(fid);
        end

        % Abrir el archivo en modo de adición
        fid = fopen(nombreArchivo, 'a');
        if fid == -1
            error("Error: No se puede abrir el archivo de texto para escritura.");
        end

        % Escribir la información en el archivo
        fprintf(fid, '%d\t%d\n', year, esBisiesto);

        % Mostrar el resultado en la consola
        disp("Registro guardado en el archivo de texto:");
        disp([year, esBisiesto]);

        % Cerrar el archivo
        fclose(fid);

        disp("Resultado mostrado en la consola.");
    catch
        disp("Error al guardar el registro en el archivo de texto.");
    end
end


PROBLEMA140();


