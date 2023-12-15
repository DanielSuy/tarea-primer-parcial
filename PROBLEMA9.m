pkg load database % Cargar el paquete
conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

try
    inicio = input("Ingresa el número de inicio: ");
    fin = input("Ingresa el número de fin: ");

    if inicio > fin
        fprintf("El número de inicio debe ser menor o igual al número de fin.\n");
        return;
    end

    fprintf("Los números de dos en dos desde %d hasta %d son:\n", inicio, fin);

    % Generar la secuencia de números de dos en dos
    numeros = sprintf('%d ', inicio:2:fin);

    % Mostrar la secuencia
    fprintf("%s\n", numeros);

    % Insertar en la base de datos
    query = sprintf("INSERT INTO problema91 (inicio, fin, numeros) VALUES ('%0.2f', '%0.2f', '%s');",  ...
                     inicio, fin, numeros);
    N = pq_exec_params(conn, query);

    % Escribir la secuencia generada en un archivo de texto
    try
        fid = fopen('problema9.txt', 'a');
        fprintf(fid, 'Inicio: %d\n', inicio);
        fprintf(fid, 'Fin: %d\n', fin);
        fprintf(fid, 'Numeros: %s\n', numeros);
        fclose(fid);
        fprintf("Datos guardados en 'problema9.txt'.\n");
    catch exception
        fprintf("Error al guardar en el archivo: %s\n", exception.message);
    end

catch exception
    fprintf("Error: %s\n", exception.message);
end
