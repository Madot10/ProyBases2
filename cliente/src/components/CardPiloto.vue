<template>
    <b-container>
        <b-row align-v="center">
            <b-col cols="6">
                <!-- IMG PILOTO -->
                <b-img rounded :src="check_base64(datos.imgpiloto)" fluid-grow></b-img>
            </b-col>
            <b-col cols="6">
                <!-- Nombre y bandera de nac -->
                <h3>
                    {{ datos.nombrepiloto }}
                    <b-img rounded :src="check_base64(datos.imgbanderapiloto)"></b-img>
                </h3>
                <p v-if="datos.nroparticipaciones">
                    Nro. de participaciones: {{ datos.nroparticipaciones }}
                </p>
                <p v-if="datos.annoparticipacion">
                    Año de participación: {{ datos.annoparticipacion }} <br />
                    <span v-if="datos.edad">Edad: {{ datos.edad }} años </span>
                </p>
                <p v-if="datos.fechanacimiento">
                    Fecha nacimiento: {{ new Date(datos.fechanacimiento) }} ({{ datos.edad }} años)
                    <br />
                    <span v-if="datos.fechafallecimiento != null"
                        >{{ new Date(datos.fechafallecimiento) }} <br
                    /></span>
                </p>
                <div v-if="datos.cantparticipaciones">
                    <hr />
                    <h5>Datos</h5>
                    <p>
                        Primera participación: {{ datos.annoprimeraparticipacion }} <br />
                        Participaciones: {{ datos.cantparticipaciones }} <br />
                        Veces en el podium: {{ datos.cantpodium }} <br />
                        Veces vencedor: {{ datos.cantprimerlugar }} <br />
                    </p>
                </div>
            </b-col>
        </b-row>
    </b-container>
</template>

<script>
export default {
    props: ["datos"],
    data() {
        return {};
    },
    methods: {
        //check base64 encabezado
        check_base64(b64) {
            if (!b64.includes("data:image")) {
                return "data:image/jpeg;base64," + b64;
            } else {
                return b64;
            }
        },
    },
};
</script>

<style></style>
