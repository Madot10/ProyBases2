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
                    {{ datos.nroequipo }} - {{ datos.nombreequipo }}
                    <b-img rounded src="https://picsum.photos/25/25/"></b-img>
                </h3>
                <!--CATEGORIA Veh-->
                <p>{{ datos.categoria }}</p>
                <!--Modelo Veh-->
                <p>{{ datos.nombrevehiculo }}</p>
                <!--Motor Motor-->
                <p>{{ datos.modelomotor }} {{ datos.cilindros }} {{ datos.cc }}cc</p>

                <!-- ENSAYO -->
                <h5>ENSAYO</h5>
                <p>
                    Puesto: {{ datos.puestoensayo }} <br />
                    Mejor tiempo: {{ datos.mejorvueltaensayo }} <br />
                    Velocidad media: {{ datos.velmediaensayo }} Km/h
                </p>
            </b-col>
            <b-col cols="1">
                <!-- Puesto -->
                <h1>{{ tipo_event == "car" ? datos.puestocarrera : datos.puestoensayo }}°</h1>
            </b-col>
        </b-row>
        <br />

        <!-- 2da franja / Pilotos -->
        <h3>PILOTOS</h3>
        <b-row>
            <b-col v-for="(pilot, i) in datos.pilotos" :key="i">
                <PillPiloto :datos="pilot"></PillPiloto
            ></b-col>
        </b-row>
        <br />

        <!-- 3era franja / Numeros (CARRERA) -->
        <h3>CARRERA</h3>
        <p>Mejor tiempo: {{ datos.mejorvueltacarrera }}</p>
        <b-row>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="100" :sections="data_nro_v"
                    ><h3 style="margin: 0;">{{ datos.nrovueltascarrera }}</h3>
                    Nro. de vueltas</vc-donut
                >
            </b-col>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="100" :sections="data_km"
                    ><h3 style="margin: 0;">{{ datos.distrecorrida }}</h3>
                    Km. recorridos</vc-donut
                >
            </b-col>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="100" :sections="data_vel_media"
                    ><h3 style="margin: 0;">{{ datos.velmediacarrera }}</h3>
                    Vel. Media (Km/h)</vc-donut
                >
            </b-col>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="100" :sections="data_dif_v"
                    ><h3 style="margin: 0;">{{ datos.difvueltas }}</h3>
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
    props: ["datos", "tipo_event"],
    data() {
        return {
            sections: [{ value: 300, color: "#1589CB" }],
            data_nro_v: [{ value: Math.floor(Math.random() * 100), color: "#1589CB" }],
            data_km: [{ value: Math.floor(Math.random() * 100), color: "#1589CB" }],
            data_vel_media: [{ value: Math.floor(Math.random() * 100), color: "#1589CB" }],
            data_dif_v: [{ value: Math.floor(Math.random() * 100), color: "#1589CB" }],
        };
    },
    created() {},
};
</script>

<style>
.card {
    width: 100%;
}
</style>
