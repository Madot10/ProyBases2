<template>
    <ScreenWindow>
        <br />
        <b-container class="h-100 ">
            <b-row class="h-100" align-v="center">
                <h3 class="text-center mb-2 w-100">
                    Simulación con los datos del año - {{ $route.params.anno_ref }}
                </h3>
                <CardClima :datos="datos_clima" v-show="!is_loading"></CardClima>

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
import CardClima from "../components/CardClima.vue";

export default {
    components: { ScreenWindow, CardRaking, CardClima },
    data() {
        return {
            is_loading: true,
            mensajes: [
                "Encendiendo luces",
                "Disfrutando la velocidad",
                "'Velocidad, soy veloz' - Rayo Mcqueen",
                "Visualizando meta",
                "'Correr, competir, lo llevo en la sangre, es parte de mi vida' - Ayrton Senna",
                "'El peso es el enemigo' - Colim Chapman",
                "'Si todo parece bajo control, es que no vas suficientemente rápido' - Gilles Villeneuve",
                "'Y solamente en la competición, yo veo la vida' - Enzo Ferrari",
                "'El motor era lo mejor del 917. Los pilotos preferimos los motroes grandes' - Richard Attwood",
            ],
            frase_activa: "Iniciando simulación...",
            datos_rank: [],
            datos_clima: [],
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

            let urlClimaApi = `http://localhost:3000/clima/2020`;

            //Solicitamos datos
            fetch(urlApi)
                .then((response) => {
                    return response.json();
                })
                .then((sim_data) => {
                    console.log("DATOS OBTENIDOS", sim_data);
                    this.generar_rank(sim_data);

                    //Solicitar clima
                    fetch(urlClimaApi)
                        .then((response) => {
                            return response.json();
                        })
                        .then((clima_data) => {
                            console.log("CLIMA ", clima_data);

                            this.datos_clima = clima_data;

                            //Simulacion finalizada
                            this.is_loading = false;
                        });
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
