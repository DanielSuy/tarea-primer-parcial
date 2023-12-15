pkg load database % Cargar el paquete
conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

try
    palabra = input("Ingresa una palabra: ", "s");
    palabra = lower(palabra);  % Convertir la palabra a minúsculas
    vocales = 'aeiouáéíóú';  % Definir las vocales en minúsculas (puedes agregar las vocales acentuadas si lo deseas)
    contador_vocales = zeros(1, length(vocales));

    for i = 1:length(palabra)
        vocal = palabra(i);
        if ismember(vocal, vocales)
            indice = find(vocales == vocal);
            contador_vocales(indice) = contador_vocales(indice) + 1;
        end
    end

    a = contador_vocales(1);
    e = contador_vocales(2);
    i = contador_vocales(3);
    o = contador_vocales(4);
    u = contador_vocales(5);

    fprintf("Resultados:\n");
    fprintf("A=%d\n", a);
    fprintf("E=%d\n", e);
    fprintf("I=%d\n", i);
    fprintf("O=%d\n", o);
    fprintf("U=%d\n", u);

    % Insertar en la base de datos
    query = sprintf("INSERT INTO problema11 (palabra, a, e, i, o, u) VALUES ('%s', '%d', '%d', '%d', '%d', '%d');", ...
                     palabra, a, e, i, o, u);
    N = pq_exec_params(conn, query);

    % Escribir en el archivo de texto
    try
        fid = fopen('problema11.txt', 'a'); % Cambio 'w' a 'a' para modo de adición
        fprintf(fid, 'Palabra: %s\n', palabra);
        fprintf(fid, 'A=%d\n', a);
        fprintf(fid, 'E=%d\n', e);
        fprintf(fid, 'I=%d\n', i);
        fprintf(fid, 'O=%d\n', o);
        fprintf(fid, 'U=%d\n', u);
        fclose(fid);
        fprintf("Datos guardados en 'problema11.txt'.\n");
    catch exception
        fprintf("Error al guardar en el archivo: %s\n", exception.message);
    end

catch exception
    fprintf("Error: %s\n", exception.message);
end




