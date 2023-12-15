% Cargar el paquete de base de datos
pkg load database

try
    % Conectar a la base de datos
    conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

    % Solicitar al usuario que ingrese un número
    numero = input("Ingresa un número: ");

    % Calcular la suma de los números desde 0 hasta el número ingresado
    Suma = sum(0:numero);

    % Mostrar el resultado
    fprintf("La suma de los números desde 0 hasta %d es: %d\n", numero, Suma);

    % Insertar en la base de datos
    query = sprintf("INSERT INTO problema4 (numero, suma) VALUES ('%d', '%d');", numero, Suma);
    N = pq_exec_params(conn, query);

    % Generar y actualizar un archivo de texto
    fid = fopen('problema4.txt', 'a'); % Abrir el archivo en modo de anexar (append)
    fprintf(fid, 'Intento registrado con éxito. Número: %d, Suma: %d\n', numero, Suma);
    fclose(fid);

    % Cerrar la conexión a la base de datos
    pq_close(conn);
catch
    disp("Error al conectar a la base de datos o al procesar la información.");
end


