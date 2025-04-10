import {createApp} from 'vue'
import App from './App.vue'
import PatientenPage from "./components/PatientenPage.vue";
import RezeptePage from "./components/RezeptePage.vue";
import TerminePage from "./components/TerminePage.vue";
import RechnungenPage from "./components/RechnungenPage.vue";
import {createRouter, createWebHistory} from "vue-router";
import PrimeVue from 'primevue/config';

import HomePage from "./components/HomePage.vue";
import {ConfirmationService, DialogService, ToastService} from "primevue";
import {client} from "./client";

const routes = [
    {path: '/', component: HomePage},
    {path: '/patienten', component: PatientenPage},
    {path: '/rezepte', component: RezeptePage},
    {path: '/termine', component: TerminePage},
    {path: '/rechnungen', component: RechnungenPage},
]

const app = createApp(App);

const router = createRouter({
    history: createWebHistory(),
    routes,
})


client.setConfig({
    baseUrl: 'http://localhost:8080',
})

app
    .use(router)
    .use(PrimeVue, {
        theme: 'none'
    })
    .use(ToastService)
    .use(ConfirmationService)
    .use(DialogService)
    .mount('#app')