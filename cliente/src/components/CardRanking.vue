<template>
    <b-card class="card">
        <!-- PRIMERA FILA DE DATOS -->
        <b-row>
            <b-col cols="5">
                <!-- IMG VEHICULO -->
                <b-img rounded :src="datos.imgvehiculo" fluid-grow></b-img>
            </b-col>
            <b-col cols="6">
                <!-- Nro equipo, Nombre y bandera de nac -->
                <h3>
                    {{ datos.nroequipo }} - {{ datos.nombreequipo }}
                    <b-img
                        id="img-pais"
                        rounded
                        :src="'data:image/png;base64,' + datos.imgbanderaequipo"
                    ></b-img>
                </h3>
                <!-- ANO DE PARTICIPACION -->
                <p v-if="fecha">
                    <b>{{ new Date(fecha).getFullYear() }}</b>
                </p>
                <!--CATEGORIA Veh-->
                <p>{{ datos.categoria }}</p>
                <!--Modelo Veh-->
                <p>{{ datos.nombrevehiculo }}</p>
                <!--Motor Motor-->
                <p>{{ datos.modelomotor }} {{ datos.cilindros }} {{ datos.cc }}cc</p>

                <!-- ENSAYO -->
                <div v-if="hora == null">
                    <h5>ENSAYO</h5>
                    <p>
                        Puesto: {{ datos.puestoensayo }} <br />
                        Mejor tiempo: {{ datos.mejorvueltaensayo }} <br />
                        Velocidad media: {{ datos.velmediaensayo }} Km/h
                    </p>
                </div>
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
        <b-row v-if="f_mostrar_chart">
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="nro_v" :sections="data_nro_v"
                    ><h3 style="margin: 0;">{{ datos.nrovueltascarrera }}</h3>
                    Nro. de vueltas</vc-donut
                >
            </b-col>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="km" :sections="data_km"
                    ><h3 style="margin: 0;">{{ datos.distrecorrida }}</h3>
                    Km. recorridos</vc-donut
                >
            </b-col>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="vel_media" :sections="data_vel_media"
                    ><h3 style="margin: 0;">{{ datos.velmediacarrera }}</h3>
                    Vel. Media (Km/h)</vc-donut
                >
            </b-col>
            <b-col>
                <vc-donut :size="150" :thickness="25" :total="dif_v" :sections="data_dif_v"
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
    props: ["datos", "tipo_event", "limites", "hora", "fecha"],
    data() {
        return {
            data_nro_v: [{ value: 1, color: "#1589CB" }],
            data_km: [{ value: 1, color: "#1589CB" }],
            data_vel_media: [{ value: 1, color: "#1589CB" }],
            data_dif_v: [{ value: 1, color: "#1589CB" }],
            //flag
            f_mostrar_chart: false,
            //limites
            nro_v: 1,
            km: 1,
            vel_media: 1,
            dif_v: 1,
        };
    },
    created() {
        //Limites de charts
        this.nro_v = this.limites.nro_v;
        this.km = this.limites.km + 1;
        this.vel_media = this.limites.vel_media + 1;
        this.dif_v = this.limites.dif_v;

        this.data_nro_v[0].value = Number(this.datos.nrovueltascarrera);
        this.data_km[0].value = Number(this.datos.distrecorrida);
        this.data_vel_media[0].value = Number(this.datos.velmediacarrera);
        this.data_dif_v[0].value = Number(this.datos.difvueltas);

        this.f_mostrar_chart = true;
    },
};
</script>

<style>
.card {
    width: 100%;
}

#img-pais {
    max-width: 30px;
}
</style>
