% Cargar el paquete de base de datos
pkg load database

try
    % Conectar a la base de datos
    conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

    % Inicializar el contador de números impares
    contador_impares = 0;

    % Mostrar e insertar en la base de datos los números impares del 1 al 100
    fprintf("Números impares del 1 al 100:\n");
    numeros = "";
    for num = 1:2:100
        fprintf("%d ", num);
        contador_impares = contador_impares + 1;
        numeros = sprintf("%s%d ", numeros, num);
    end

    % Mostrar el total de números impares
    fprintf("\n\nTotal de números impares: %d\n", contador_impares);

    % Insertar en la base de datos
    query = sprintf("INSERT INTO problema5 (numeros, resultado) VALUES ('%s', '%d');", numeros, contador_impares);
    N = pq_exec_params(conn, query);

    % Generar y actualizar un archivo de texto
    fid = fopen('prolema5.txt', 'a'); % Abrir el archivo en modo de anexar (append)
    fprintf(fid, 'Intento registrado con éxito. Números impares: %s, Total: %d\n', numeros, contador_impares);
    fclose(fid);

    % Cerrar la conexión a la base de datos
    pq_close(conn);
catch
    disp("Error al conectar a la base de datos o al procesar la información.");
end



