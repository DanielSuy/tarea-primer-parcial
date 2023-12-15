pkg load database % Cargar el paquete
conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

try
    num1 = input("Ingresa el primer número: ");
    num2 = input("Ingresa el segundo número: ");

    mayor = max(num1, num2);
    menor = min(num1, num2);

    fprintf("La lista de números desde %d hasta %d es:\n", mayor, menor);

    % Generar la lista de números desde el mayor hasta el menor
    numeros = sprintf('%d ', mayor:-1:menor);

    % Mostrar la lista de números
    fprintf("%s\n", numeros);

    % Insertar en la base de datos
    query = sprintf("INSERT INTO problema10 (num1, num2, numeros) VALUES (%d, %d, '%s');",  ...
                     num1, num2, numeros);
    N = pq_exec_params(conn, query);

    % Escribir la lista de números en un archivo de texto
    try
        fid = fopen('problema10.txt', 'a');
        fprintf(fid, 'Numero1: %d\n', num1);
        fprintf(fid, 'Numero2: %d\n', num2);
        fprintf(fid, 'Numeros: %s\n', numeros);
        fclose(fid);
        fprintf("Datos guardados en 'problema10.txt'.\n");
    catch exception
        fprintf("Error al guardar en el archivo: %s\n", exception.message);
    end

catch exception
    fprintf("Error: %s\n", exception.message);
end



