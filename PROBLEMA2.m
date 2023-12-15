% Cargar el paquete de base de datos
pkg load database
    % Conectar a la base de datos
    conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

    % Solicitar al usuario que ingrese un número
    numero = input("Ingresa un número: ");
    fprintf("Número ingresado: %d\n", numero);

    % Inicializar una cadena para almacenar los divisores
    divisores = "";

    % Encontrar los divisores del número
    for divisor = 1:numero
        if rem(numero, divisor) == 0
            fprintf("%d ", divisor);
            divisores = sprintf("%s%d ", divisores, divisor);
        end
    end

    % Mostrar los divisores como lista de texto
    fprintf("\nDivisores como lista de texto: ");
    disp(divisores);

% Redondear el número a un entero
numero_entero = round(numero);

% Insertar en la base de datos
query = sprintf("INSERT INTO problema2 (divisores, numero) VALUES ('{%s}', '%d');", divisores, numero_entero);
N = pq_exec_params(conn, query);


    % Generar y actualizar un archivo de texto
    fid = fopen('problema2.txt', 'a'); % Abrir el archivo en modo de anexar (append)
    fprintf(fid, 'Intento registrado con éxito. Divisores: %s, Número: %0.2f\n', divisores, numero);
    fclose(fid);



