% Cargar el paquete de base de datos
pkg load database


    % Función para comparar números y registrar en la base de datos
    function comparar_numeros()
        % Conectar a la base de datos
        conn = pq_connect(setdbopts('dbname','corto','host','localhost','port','5432','user','postgres','password','2020'));

        % Solicitar al usuario que ingrese tres números
        num1 = input("Ingresa el primer número: ");
        num2 = input("Ingresa el segundo número: ");
        num3 = input("Ingresa el tercer número: ");

        % Comparar los números y realizar operaciones según el caso
        if num1 > num2 && num1 > num3
            suma = num1 + num2 + num3;
            fprintf("El primer número es el más grande. Suma: %d\n", suma);
            mayor=num1;
            resultado=suma;
        elseif num2 > num1 && num2 > num3
            multiplicacion = num1 * num2 * num3;
            fprintf("El segundo número es el más grande. Multiplicación: %d\n", multiplicacion);
            mayor=num2;
            resultado=multiplicacion;
        elseif num3 > num1 && num3 > num2
            concatenado = strcat(num2str(num1), num2str(num2), num2str(num3));
            fprintf("El tercer número es el más grande. Concatenación: %s\n", concatenado);
            mayor=num3;
            resultado=concatenado;
        elseif num1 == num2 && num1 ~= num3
            fprintf("El tercer número es diferente. Valor: %d\n", num3);
            mayor=num3;
            resultado=num3;
        elseif num2 == num3 && num2 ~= num1
            fprintf("El primer número es diferente. Valor: %d\n", num1);
            mayor=num1;
            resultado=num1;
        elseif num1 == num3 && num1 ~= num2
            fprintf("El segundo número es diferente. Valor: %d\n", num2);
            mayor=num2;
            resultado=num2;
        else
            fprintf("Todos los números son iguales: %d %d %d. Todos son iguales.\n", num1, num2, num3);
            mayor=num3;
            resultado=num3;
        end

        % Crear la instrucción SQL para insertar en la tabla 'problema1'
        Instruccion = strcat("insert into problema1 (numero1, numero2, numero3, mayor, resultado) values( ", num2str(num1), "," , num2str(num2), "," , num2str(num3), "," , num2str(mayor), "," ,  num2str(resultado), ");" );

        % Ejecutar la instrucción SQL para registrar el intento
        Registro = pq_exec_params(conn, Instruccion);
        disp("Se ha registrado su intento");

        % Generar y actualizar un archivo de texto con información del intento
        fid = fopen('problema1.txt', 'a'); % Abrir el archivo en modo de anexar (append)
        fprintf(fid, 'Intento registrado con éxito. Mayor: %d, Resultado: %s\n', mayor, num2str(resultado));
        fclose(fid);

        % Realizar una consulta SQL para ver datos en la tabla 'problema1'
        N=pq_exec_params(conn, 'select * from problema1;');
    end

    % Llamar a la función para comparar números y registrar en la base de datos
    comparar_numeros();





