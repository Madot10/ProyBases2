<template>
    <ScreenWindow>
        <br />

        <!-- MENSAJE - CARGA -->
        <div v-show="is_loading == true" class="text-center mx-auto">
            <h3>{{ frase_activa }}</h3>
            <b-icon icon="minecart" animation="cylon" font-scale="4"></b-icon>
        </div>
    </ScreenWindow>
</template>

<script>
import ScreenWindow from "../components/ScreenWindow.vue";

export default {
    components: { ScreenWindow },
    data() {
        return {
            is_loading: true,
            mensajes: [
                "Encendiendo luces",
                "Animando al publico",
                "Disfrutando la velocidad",
                "Velocidad, soy veloz",
                "Probando cronómetros",
                "Visualizando meta",
            ],
            frase_activa: "Iniciando simulación...",
        };
    },
    methods: {
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
