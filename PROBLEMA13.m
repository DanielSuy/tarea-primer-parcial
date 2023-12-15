pkg load database % cargar el paquete
conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

historial = {};

function calcular_aprobacion(notas)
    global historial;
    pkg load database % cargar el paquete
    conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));
    promedio = sum(notas) / length(notas);

    if promedio >= 60
        resultado = "Aprobado";
    else
        resultado = "Reprobado";
    end

    historial{end + 1} = sprintf("Notas: [%d, %d, %d] | Promedio: %.2f | Resultado: %s", notas(1), notas(2), notas(3), promedio, resultado);

    fprintf("Promedio: %.2f | %s\n", promedio, resultado);
    % Insertar en la base de datos
    query = sprintf("INSERT INTO problema13 (nota1, nota2, nota3, promedio, resultado) VALUES ('%0.2f', '%0.2f', '%0.2f', '%0.2f', '%s');",  ...
                 notas(1), notas(2), notas(3), promedio, resultado);
    N = pq_exec_params(conn, query);

    % Guardar en el archivo de texto
    guardar_en_archivo(historial{end});
end

function mostrar_historial()
    fprintf("Historial:\n");
    % Leer datos desde el archivo de texto
    fid = fopen('problema13.txt', 'r');
    if fid ~= -1
        while ~feof(fid)
            line = fgetl(fid);
            fprintf("%s\n", line);
        end
        fclose(fid);
    else
        fprintf("No hay historial disponible.\n");
    end
end

function guardar_en_archivo(resultado)
    fid = fopen('problema13.txt', 'a');
    fprintf(fid, '%s\n', resultado);
    fclose(fid);
end

while true
    fprintf("\n1. Calcular aprobación\n");
    fprintf("2. Mostrar historial\n");
    fprintf("3. Salir\n");

    opcion = input("Selecciona una opción: ");

    switch opcion
        case 1
            notas = zeros(1, 3);
            for i = 1:3
                notas(i) = input(sprintf("Ingresa la nota %d: ", i));
            end
            calcular_aprobacion(notas);
        case 2
            mostrar_historial();
        case 3
            fprintf("salio del programa\n");
            break;
        otherwise
            fprintf("Opción no válida. Por favor, elige una opción válida.\n");
    end
end

