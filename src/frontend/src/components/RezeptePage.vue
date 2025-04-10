<script setup lang="ts">
import {ref, watch} from 'vue'
import {useRoute} from 'vue-router'
import {
  createFromImage,
  type CreateFromImageResponse,
  getPatienten,
  getRezepte,
  type PatientDto,
  type RezeptDto
} from '../client'
import {
  Button,
  Card,
  DataView,
  FileUpload,
  type FileUploadUploaderEvent,
  Image,
  ProgressSpinner,
  Select,
  Toast
} from "primevue";
import {useToast} from "primevue/usetoast";
import Icon from "./Icon.vue";
import dateFormat from "dateformat";
import {Patient} from "./models.ts";
import type {SelectFilterEvent} from "primevue/select";

const route = useRoute()

const loading = ref(false)
const rezepte = ref<Array<RezeptDto>>()
const error = ref<string | null>(null)

watch(() => route.params.id, fetchData, {immediate: true})

async function fetchData() {
  error.value = null
  loading.value = true

  let response = await getRezepte();

  if (response.error) {
    error.value = response.error!!.toString()
    loading.value = false
    return;
  }

  rezepte.value = response.data!!
  loading.value = false
}

const toast = useToast();
const createRezeptFromImageResponse = ref<CreateFromImageResponse | null>(null)
const isCreateRezeptFromImageLoading = ref(false)
const isCreateRezeptFromImageError = ref(false)
const currentRezeptImage = ref<File | null>(null)

const isPatientenLoading = ref(false)
const patienten = ref<Patient[] | null>(null)
const selectedPatient = ref<Patient | null>(null)

async function fetchPatienten(query: string = '') {
  isPatientenLoading.value = true;
  patienten.value = null;
  let res = await getPatienten(
      {
        query: {filter: query},
        responseTransformer: async (data: any) => (data as PatientDto[]).map(p => new Patient(p))
      }
  );
  await new Promise(resolve => setTimeout(resolve, 2000));
  if (res.data) {
    patienten.value = res.data as Patient[];
  }
  isPatientenLoading.value = false;
}

async function filterPatienten(event: SelectFilterEvent) {

  await fetchPatienten(event.value as string);
}

async function onAdvancedUpload(event: FileUploadUploaderEvent) {
  if (!patienten.value) {
    await fetchPatienten();
  }

  currentRezeptImage.value = null;
  isCreateRezeptFromImageError.value = false;
  isCreateRezeptFromImageLoading.value = true;

  let res = await createFromImage(
      {
        body: {file: event.files as File},
      });

  if (res.error) {
    isCreateRezeptFromImageError.value = true;
  }
  if (res.data) {
    createRezeptFromImageResponse.value = res.data
  }

  toast.add({severity: 'info', summary: 'Success', detail: 'File Uploaded', life: 3000});

  let existingPatient = createRezeptFromImageResponse.value?.existingPatient as PatientDto;
  selectedPatient.value = existingPatient ? new Patient(existingPatient) : null;

  isCreateRezeptFromImageLoading.value = false;
  currentRezeptImage.value = event.files as File;
}

</script>

<template>
  <main class="flex flex-col gap-8">
    <Toast></Toast>
    <Card
        v-if="!createRezeptFromImageResponse"
        class="w-full">
      <template #content>
        <div
            v-if="isCreateRezeptFromImageLoading || !createRezeptFromImageResponse"
            class="flex flex-col place-content-center place-items-center p-4">
          <FileUpload
              v-if="!isCreateRezeptFromImageLoading"
              auto
              custom-upload
              @uploader="onAdvancedUpload"
              :multiple="false"
              accept="image/*"
              :maxFileSize="1000000"
              mode="basic"
              choose-label="Rezept hochladen"
              class="h-10"
          >
            <template #uploadicon>
              <Icon>add</Icon>
            </template>
          </FileUpload>

          <div v-else class="h-10 flex flex-col gap-2 place-content-center">
            <ProgressSpinner class="w-10 h-10"/>
            <p class="text-muted-color">Analysiere Rezept...</p>
          </div>
        </div>
      </template>
    </Card>

    <template v-else>
      <Card>
        <template #title>Rezept erstellen</template>
        <template #content>
          <div class="flex flex-row gap-4 max-sm:flex-col ">
            <div class="">
              <Image
                  image-class="sm:max-h-48"
                  zoom-in-disabled
                  zoom-out-disabled
                  preview
                  :src="'http://localhost:8080' + createRezeptFromImageResponse.path"/>
            </div>
            <div class="flex-grow flex flex-col gap-4">
              <p>
                {{
                  [createRezeptFromImageResponse.patient.titel, createRezeptFromImageResponse.patient.vorname, createRezeptFromImageResponse.patient.nachname].join(" ")
                }} <br/>
                geb. am {{ dateFormat(new Date(createRezeptFromImageResponse.patient.geburtstag), "dd.mm.yyyy") }} <br/>
                {{ createRezeptFromImageResponse.patient.strasse }} {{
                  createRezeptFromImageResponse.patient.hausnummer
                }}
                <br/>
                {{ createRezeptFromImageResponse.patient.postleitzahl }} {{
                  createRezeptFromImageResponse.patient.stadt
                }}
                <br/>
              </p>
              <div>
                <h2 class="font-bold">Behandlungen</h2>
                <ul>
                  <li v-for="pos in createRezeptFromImageResponse.rezept.rezeptpositionen">
                    {{ pos.anzahl }}x - {{ pos.behandlungsart.name }}
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </template>
      </Card>

      <Card>
        <template #title>
          Patient verknüpfen
        </template>
        <template #content>
          <div>
            <Select v-model="selectedPatient"
                    :options="patienten!!"
                    :loading="isPatientenLoading"
                    filter
                    placeholder="Patient auswählen"
                    @filter="filterPatienten"
                    data-key="id"


            >
              <template #value="slotProps">
                <div v-if="slotProps.value" class="flex items-center">
                  <div>{{ (slotProps.value as Patient).getFullName() }}</div>
                </div>
                <span v-else>
                    {{ slotProps.placeholder }}
                </span>
              </template>
              <template #option="slotProps">
                <div class="flex flex-col">
                  <div>{{ (slotProps.option as Patient).getFullName() }}</div>
                  <div class="font-light text-base/5">{{ (slotProps.option as Patient).stadt }}</div>
                </div>
              </template>
              <template #footer>
                <div class="p-3">
                  <Button label="Add New" fluid severity="secondary" text size="small" icon="pi pi-plus"/>
                </div>
              </template>
            </Select>
          </div>
        </template>
      </Card>
    </template>

    <Card>
      <template #content>
        <DataView
            :value="rezepte"
            data-key="id"
        >
          <template #header>
            <h1 class="text-xl">Rezepte</h1>
          </template>
          <template #list="{items} : {items: RezeptDto[]}">
            <div v-if="items.length == 0">
              Keine Rezepte gefunden
            </div>
            <div v-else>
              {{ items.map(item => item.id) }}
            </div>
          </template>
        </DataView>
      </template>
    </Card>
  </main>
</template>

<style scoped>

</style>
