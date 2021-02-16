<template>
    <b-card class="card">
        <!-- PRIMERA FILA DE DATOS -->
        <b-row>
            <b-col cols="6">
                <!-- IMG VEHICULO -->
                <b-img rounded :src="datos.imgvehiculo" fluid-grow></b-img>
            </b-col>
            <b-col cols="6">
                <!-- Nro equipo, Nombre y bandera de nac -->
                <h3>
                    {{ datos.nroequipo }} - {{ datos.nombreequipo }}
                    <b-img rounded :src="datos.imgbanderaequipo"></b-img>
                </h3>
                <p>({{datos.fechapartipacion || datos.annoparticipacion}})</p>
               
                <!--CATEGORIA Veh-->
                <p>{{ datos.categoria || datos.vehcategoria }}</p>
                <!--Modelo Veh-->
                <p>{{ datos.nombrevehiculo || datos.modelo }}</p>
                 <!--Motor Motor-->
                <p v-if="datos.modelomotor">{{ datos.modelomotor }} {{ datos.cilindros }} {{ datos.cc }}cc</p>
                <!-- Fabricantes-->
                <p v-if="datos.fabneumatico">
                    Fab. neumáticos: {{datos.fabneumatico}} <br>
                    Fabricante: {{datos.fabricante}} <br>
                    Tipo: {{datos.tipoveh == 'nh' ? 'No híbrido' : datos.tipoveh == 'h ' ? 'Híbrido' : '' }}
                </p>

               
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

        </b-row>

        <br />
    </b-card>
</template>

<script>
import PillPiloto from "./PillPiloto.vue";

export default {
    components: { PillPiloto },
    props: ["datos", "reporte"],
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
    methods:{
         //check base64 encabezado
        check_base64(b64) {
            if (!b64.includes("data:image")) {
                return "data:image/jpeg;base64," + b64;
            } else {
                return b64;
            }
        },
    }
  
};
</script>

<style>
.card {
    width: 100%;
}

</style>
