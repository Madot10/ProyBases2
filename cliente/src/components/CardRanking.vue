<template>
    <b-card class="card">
        <!-- PRIMERA FILA DE DATOS -->
        <b-row>
            <b-col cols="5">
                <!-- IMG VEHICULO -->
                <b-img rounded src="https://picsum.photos/300/200/" fluid-grow></b-img>
            </b-col>
            <b-col cols="6">
                <!-- Nro equipo, Nombre y bandera de nac -->
                <h3>
                    ## - EQUIPO MATUSALENA
                    <b-img rounded src="https://picsum.photos/25/25/"></b-img>
                </h3>
                <!--CATEGORIA Veh-->
                <p>LMP 900</p>
                <!--Modelo Veh-->
                <p>AUDI MOTORE</p>
                <!--Motor Veh-->
                <p>Motor V8 33000cc</p>

                <!-- ENSAYO -->
                <h5>ENSAYO</h5>
                <p>
                    Puesto: ##### <br />
                    Mejor tiempo: ##### <br />
                    Velocidad media: ##### Km/h
                </p>
            </b-col>
            <b-col cols="1">
                <!-- Puesto -->
                <h1>1°</h1>
            </b-col>
        </b-row>
        <br />

        <!-- 2da franja / Pilotos -->
        <h3>PILOTOS</h3>
        <b-row>
            <b-col><PillPiloto></PillPiloto></b-col>
            <b-col><PillPiloto></PillPiloto></b-col>
            <b-col><PillPiloto></PillPiloto></b-col>
        </b-row>
        <br />

        <!-- 3era franja / Numeros (CARRERA) -->
        <h3>CARRERA</h3>
        <p>Mejor tiempo: ####</p>
        <b-row>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="400" :sections="sections"
                    ><h3 style="margin: 0;">100</h3>
                    Nro. de vueltas</vc-donut
                >
            </b-col>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="400" :sections="sections"
                    ><h3 style="margin: 0;">5200300</h3>
                    Km. recorridos</vc-donut
                >
            </b-col>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="400" :sections="sections"
                    ><h3 style="margin: 0;">200.5</h3>
                    Vel. Media (Km/h)</vc-donut
                >
            </b-col>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="400" :sections="sections"
                    ><h3 style="margin: 0;">10</h3>
                    Dif. vueltas</vc-donut
                >
            </b-col>
        </b-row>

        <br />
    </b-card>
</template>

<script>
import PillPiloto from "./PillPiloto.vue";

export default {
    components: { PillPiloto },
    data() {
        return {
            sections: [{ value: 300, color: "#1589CB" }],
        };
    },
};
</script>

<style>
.card {
    width: 100%;
}
</style>
