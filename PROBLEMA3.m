% Cargar el paquete de base de datos
pkg load database

try
    % Conectar a la base de datos
    conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

    % Solicitar al usuario que ingrese una palabra
    palabra = input("Ingresa una palabra: ", "s");

    % Convertir la palabra a minúsculas para contar las vocales sin distinción de mayúsculas o minúsculas
    palabra = lower(palabra);

    % Definir las vocales en minúsculas (puedes agregar las vocales acentuadas si lo deseas)
    vocales = 'aeiouáéíóú';

    % Contar las vocales en la palabra
    contador = 0;

    for i = 1:length(palabra)
        if ismember(palabra(i), vocales)
            contador = contador + 1;
        end
    end

    % Mostrar el resultado
    fprintf("La palabra '%s' tiene %d vocales.\n", palabra, contador);

    % Insertar en la base de datos
    query = sprintf("INSERT INTO problema3 (palabra, vocales) VALUES ('%s', '%d');", palabra, contador);
    N = pq_exec_params(conn, query);

    % Generar y actualizar un archivo de texto
    fid = fopen('problema3.txt', 'a'); % Abrir el archivo en modo de anexar (append)
    fprintf(fid, 'Intento registrado con éxito. Palabra: %s, Vocales: %d\n', palabra, contador);
    fclose(fid);

    % Cerrar la conexión a la base de datos
    pq_close(conn);
catch
    disp("Error al conectar a la base de datos o al procesar la información.");
end


