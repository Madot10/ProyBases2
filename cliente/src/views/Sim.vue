<template>
    <ScreenWindow>
        <br />
        <b-container class="h-100 ">
            <b-row class="h-100" align-v="center">
                <h3 class="text-center mb-2 w-100">
                    Simulación con los datos del año - {{ $route.params.anno_ref }}
                </h3>
                <div v-for="(parti, i) in datos_rank" :key="i">
                    <CardRaking :datos="parti" tipo_event="car" :limites="limites"></CardRaking>
                    <br />
                </div>
                <!-- MENSAJE - CARGA -->
                <div v-show="is_loading == true" class="text-center mx-auto">
                    <h3>{{ frase_activa }}</h3>
                    <b-icon icon="minecart" animation="cylon" font-scale="4"></b-icon>
                </div>
            </b-row>
        </b-container>
    </ScreenWindow>
</template>

<script>
import ScreenWindow from "../components/ScreenWindow.vue";
import CardRaking from "../components/CardRanking.vue";

export default {
    components: { ScreenWindow, CardRaking },
    data() {
        return {
            is_loading: true,
            mensajes: [
                "Encendiendo luces",
                "Animando al publico",
                "Disfrutando la velocidad",
                "'Velocidad, soy veloz' - Rayo Mcqueen",
                "Probando cronómetros",
                "Visualizando meta",
            ],
            frase_activa: "Iniciando simulación...",
            datos_rank: [],
            limites: {
                nro_v: 0,
                km: 0,
                vel_media: 0,
                dif_v: 0,
            },
        };
    },
    methods: {
        //Guardar mayor valor
        guardar_valor_alto(valor, tipo) {
            if (this.limites[tipo] < Number(valor)) {
                //guardamos nuevo
                this.limites[tipo] = Number(valor);
            }
        },
        //Generar array agrupados
        generar_rank(datos) {
            let aux_rank = [];
            //Array nuevo de datos
            let aux_arr = [];

            //Agrupemos por pilotos
            datos.forEach((c, i) => {
                //Si no existe registro de equipo
                if (aux_rank[c.nroequipo] == null) {
                    //Guardamos index de array original
                    aux_rank[c.nroequipo] = i;

                    c.pilotos = [];

                    c.pilotos.push({
                        gentilicio: c.gentilicio,
                        imgbanderapiloto: c.imgbanderapiloto,
                        imgpiloto: c.imgpiloto,
                        nombrepiloto: c.nombrepiloto,
                    });

                    //Verificamos valores de limites
                    this.guardar_valor_alto(c.nrovueltascarrera, "nro_v");
                    this.guardar_valor_alto(c.distrecorrida, "km");
                    this.guardar_valor_alto(c.velmediacarrera, "vel_media");
                    this.guardar_valor_alto(c.difvueltas, "dif_v");

                    aux_arr.push(c);
                } else {
                    //Tenemos registro, guardamos
                    datos[aux_rank[c.nroequipo]].pilotos.push({
                        gentilicio: c.gentilicio,
                        imgbanderapiloto: c.imgbanderapiloto,
                        imgpiloto: c.imgpiloto,
                        nombrepiloto: c.nombrepiloto,
                    });
                }
            });
            //Guardamos
            this.datos_rank = aux_arr;
            this.is_loading = false;
        },
        //Obtener datos desde el MBD
        obtener_datos() {
            let urlApi = `http://localhost:3000/simulacion/${this.$route.params.anno_ref}/${this.$route.params.pista}/${this.$route.params.clima}`;

            //Solicitamos datos
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((sim_data) => {
                    console.log("DATOS OBTENIDOS", sim_data);
                    this.generar_rank(sim_data);
                    //Simulacion finalizada
                    this.is_loading = false;
                });
        },
        //Cambio de frase
        cambiar_frase() {
            //Mientras no haya cargado
            if (this.is_loading == true) {
                let ran_n = Math.floor(Math.random() * (this.mensajes.length - 0));
                this.frase_activa = this.mensajes[ran_n] + "...";
                setTimeout(this.cambiar_frase, 2000);
            }
        },
    },
    created() {
        this.obtener_datos();
        this.cambiar_frase();
    },
};
</script>

<style></style>
