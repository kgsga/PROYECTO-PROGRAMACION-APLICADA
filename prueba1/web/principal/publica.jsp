<!DOCTYPE html>
<html lang="es">

<head>

    <meta charset="utf-8">

    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>VENTANA PRINCIPAL - SUPERMERCADO VIRTUAL</title>

    <!-- Bootstrap -->
    <link href="/WebApplication1/css/bootstrap.min2.css" rel="stylesheet">

    <!-- Font Awesome -->
    <link href="/WebApplication1/font-awesome/css/font-awesome.min.css"
          rel="stylesheet">

    <!-- CSS -->
    <link href="/WebApplication1/css/style.css"
          rel="stylesheet">

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding-top: 105px;
            background-color: #f7f7f7;
            font-family: Arial, sans-serif;
        }


        /* =========================
           BARRA SUPERIOR
           ========================= */

        .top-bar {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 105px;
            background-color: white;
            border-bottom: 1px solid #ddd;
            z-index: 1000;
        }

        .main-row {
            height: 65px;
            display: flex;
            align-items: center;
            padding: 0 20px;
        }


        /* LOGO */

        .logo-area {
            width: 25%;
            display: flex;
            align-items: center;
        }

        .logo-area img {
            max-width: 120px;
            max-height: 45px;
        }

        .menu-button {
            border: none;
            background: white;
            font-weight: bold;
            font-size: 14px;
            margin-left: 20px;
            cursor: pointer;
        }

        .menu-button i {
            margin-right: 5px;
        }


        /* BUSCADOR */

        .search-area {
            width: 45%;
            padding: 0 20px;
        }

        .search-box {
            position: relative;
            width: 100%;
        }

        .search-box input {
            width: 100%;
            height: 40px;
            border: 1px solid #ccc;
            border-radius: 25px;
            padding: 0 50px 0 20px;
            outline: none;
        }

        .search-button {
            position: absolute;
            right: 5px;
            top: 4px;
            width: 32px;
            height: 32px;
            border: none;
            border-radius: 50%;
            background-color: #2c3e50;
            color: white;
            cursor: pointer;
        }


        /* PARTE DERECHA */

        .right-area {
            width: 30%;
            display: flex;
            align-items: center;
            justify-content: flex-end;
            gap: 20px;
        }

        .user-link {
            color: #333;
            text-decoration: none;
            font-size: 13px;
        }

        .user-link span {
            display: block;
            color: #666;
            font-size: 11px;
        }

        .user-link strong {
            font-size: 13px;
        }

        .icon-link {
            color: #333;
            font-size: 21px;
            text-decoration: none;
            position: relative;
        }

        .cart-number {
            position: absolute;
            top: -8px;
            right: -10px;
            background-color: #2c3e50;
            color: white;
            border-radius: 50%;
            font-size: 10px;
            padding: 2px 5px;
        }


        /* =========================
           BARRA SECUNDARIA
           ========================= */

        .secondary-bar {
            height: 40px;
            border-top: 1px solid #eee;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            font-size: 12px;
        }

        .location {
            color: #333;
        }

        .location i {
            margin-right: 5px;
        }

        .secondary-links {
            display: flex;
            gap: 25px;
        }

        .secondary-links a {
            color: #555;
            text-decoration: none;
        }

        .secondary-links a:hover {
            text-decoration: underline;
        }


        /* =========================
           CARRUSEL
           ========================= */

        .carousel {
            width: 100%;
            height: 500px;
            position: relative;
            overflow: hidden;
            background-color: white;
        }

        .carousel-image {
            width: 100%;
            height: 500px;
            object-fit: contain;
            display: none;
            background-color: white;
        }

        .carousel-image.active {
            display: block;
        }


        /* FLECHAS */

        .arrow {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 45px;
            height: 70px;
            border: none;
            background-color: rgba(0, 0, 0, 0.25);
            color: white;
            font-size: 30px;
            cursor: pointer;
            z-index: 10;
        }

        .arrow:hover {
            background-color: rgba(0, 0, 0, 0.5);
        }

        .left-arrow {
            left: 15px;
        }

        .right-arrow {
            right: 15px;
        }


        /* PUNTOS */

        .dots {
            position: absolute;
            bottom: 15px;
            left: 0;
            width: 100%;
            text-align: center;
            z-index: 10;
        }

        .dot {
            display: inline-block;
            width: 10px;
            height: 10px;
            margin: 0 4px;
            background-color: #ccc;
            border-radius: 50%;
            cursor: pointer;
        }

        .dot.active {
            background-color: #333;
        }


        /* =========================
           CATEGORÍAS
           ========================= */

        .categories {
            background-color: white;
            border-top: 1px solid #ddd;
            border-bottom: 1px solid #ddd;
            padding: 15px 10px;
        }

        .category-list {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 25px;
            margin: 0;
            padding: 0;
            list-style: none;
        }

        .category-list a {
            color: #0076bd;
            text-decoration: none;
            font-size: 14px;
        }

        .category-list a:hover {
            text-decoration: underline;
        }


        /* =========================
           ADAPTACIÓN PARA PANTALLAS PEQUEÑAS
           ========================= */

        @media (max-width: 768px) {

            body {
                padding-top: 150px;
            }

            .top-bar {
                height: 150px;
            }

            .main-row {
                height: 105px;
                flex-wrap: wrap;
            }

            .logo-area {
                width: 50%;
            }

            .search-area {
                width: 100%;
                order: 3;
                padding: 5px 0;
            }

            .right-area {
                width: 50%;
            }

            .secondary-bar {
                display: none;
            }

            .carousel {
                height: 350px;
            }

            .carousel-image {
                height: 350px;
            }

            .secondary-links {
                display: none;
            }
        }

    </style>

</head>


<body>


<!-- =========================
     BARRA SUPERIOR
     ========================= -->

<div class="top-bar">

    <div class="main-row">


        <!-- LOGO -->

        <div class="logo-area">

            <a href="#">

                <img src="/prueba1/image_de_principal/logo.png"
                     alt="Supermercado">

            </a>

            <button class="menu-button">

                <i class="fa fa-bars"></i>

                Menú

            </button>

        </div>


        <!-- BUSCADOR -->

        <div class="search-area">

            <div class="search-box">

                <input type="text"
                       placeholder="Buscar en el supermercado">

                <button class="search-button">

                    <i class="fa fa-search"></i>

                </button>

            </div>

        </div>


        <!-- PARTE DERECHA -->

        <div class="right-area">


            <!-- INICIAR SESIÓN -->

            <a href="../login/usuario_antiguo.jsp"
               class="user-link">

                <span>Hola,</span>

                <strong>
                    Inicia sesión
                </strong>

            </a>


            <!-- CUENTA -->

            <a href="../login/usuario_antiguo.jsp"
               class="user-link">

                <span>Mi</span>

                <strong>
                    cuenta
                </strong>

            </a>


            <!-- FAVORITOS -->

            <a href="#"
               class="icon-link">

                <i class="fa fa-heart-o"></i>

            </a>


            <!-- CARRITO -->

            <a href="#"
               class="icon-link">

                <i class="fa fa-shopping-cart"></i>

                <span class="cart-number">
                    0
                </span>

            </a>


        </div>

    </div>


    <!-- BARRA SECUNDARIA -->

    <div class="secondary-bar">


        <div class="location">

            <i class="fa fa-map-marker"></i>

            Ingresa tu ubicación

        </div>


        <div class="secondary-links">

            <a href="#">
                Tarjeta unfv
            </a>

            <a href="#">
                Vende y comisiona
            </a>

            <a href="#">
                Venta telefónica
            </a>

            <a href="#">
                Ayuda
            </a>

        </div>

    </div>

</div>



<!-- =========================
     CARRUSEL
     ========================= -->

<div class="carousel">


    <!-- IMÁGENES -->

    <img class="carousel-image active"
         src="/prueba1/image_de_principal/calzado.png"
         alt="Calzado">


    <img class="carousel-image"
         src="/prueba1/image_de_principal/tecnologia.png"
         alt="Tecnología">


    <img class="carousel-image"
         src="/prueba1/image_de_principal/ropa.png"
         alt="Ropa">



    <!-- FLECHA IZQUIERDA -->

    <button class="arrow left-arrow"
            onclick="previousImage()">

        &#10094;

    </button>


    <!-- FLECHA DERECHA -->

    <button class="arrow right-arrow"
            onclick="nextImage()">

        &#10095;

    </button>


    <!-- PUNTOS -->

    <div class="dots">

        <span class="dot active"
              onclick="showImage(0)">
        </span>

        <span class="dot"
              onclick="showImage(1)">
        </span>

        <span class="dot"
              onclick="showImage(2)">
        </span>

    </div>


</div>



<!-- =========================
     CATEGORÍAS
     ========================= -->

<div class="categories">

    <ul class="category-list">

        <li>
            <a href="#">
                Inicio
            </a>
        </li>

        <li>
            <a href="#">
                Abarrotes y Despensa
            </a>
        </li>

        <li>
            <a href="#">
                Frutas y Verduras
            </a>
        </li>

        <li>
            <a href="#">
                Carnes y Lácteos
            </a>
        </li>

        <li>
            <a href="#">
                Bebidas y Licores
            </a>
        </li>

        <li>
            <a href="#">
                Limpieza del Hogar
            </a>
        </li>

    </ul>

</div>



<!-- =========================
     JAVASCRIPT DEL CARRUSEL
     ========================= -->

<script>

    var currentImage = 0;

    var images = document.querySelectorAll(".carousel-image");

    var dots = document.querySelectorAll(".dot");


    function showImage(number) {

        images[currentImage].classList.remove("active");

        dots[currentImage].classList.remove("active");


        currentImage = number;


        images[currentImage].classList.add("active");

        dots[currentImage].classList.add("active");

    }


    function nextImage() {

        var next = currentImage + 1;

        if (next >= images.length) {

            next = 0;

        }

        showImage(next);

    }


    function previousImage() {

        var previous = currentImage - 1;

        if (previous < 0) {

            previous = images.length - 1;

        }

        showImage(previous);

    }


    /* Cambio automático cada 4 segundos */

    setInterval(function() {

        nextImage();

    }, 4000);


</script>


</body>

</html>