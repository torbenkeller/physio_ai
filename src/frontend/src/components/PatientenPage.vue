<script setup lang="ts">
import {ref, watch} from 'vue'
import {useRoute} from 'vue-router'
import {createPatient, deletePatient, getPatienten, type PatientDto, updatePatient} from '../client'
import {Button, Card, Column, ContextMenu, DataTable, Dialog, Toast, useToast} from "primevue";
import Icon from "./Icon.vue";
import dateFormat from "dateformat";
import PatientForm from "./PatientForm.vue";
import type {DataTableRowContextMenuEvent} from "primevue/datatable";
import {Patient} from "./models.ts";

const route = useRoute()

const loading = ref(false)
const patienten = ref<Array<Patient> | null>(null)
const error = ref<string | null>(null)

watch(() => route.params.id, fetchData, {immediate: true})

async function fetchData() {
  error.value = patienten.value = null
  loading.value = true

  let response = await getPatienten({
    responseTransformer: async (data: any) => {
      return (data as PatientDto[]).map((p: PatientDto) => new Patient(p))
    },
  });
  if (response.error) {
    error.value = response.error.toString()
    loading.value = false
    return;
  }

  patienten.value = response.data!! as Patient[];
  loading.value = false
}

const onDialogSubmit = async (patient: Patient) => {
  patientDialog.value = false;
  let index = patienten.value!.findIndex((p) => p.id == patient.id)
  if (index == -1) {
    let response = await createPatient({
      body: patient,
      responseTransformer: async (data: any) => new Patient(data)
    });
    patienten.value!!.push(response.data!! as Patient)
    return
  }
  let response = await updatePatient({
    path: {id: patient.id},
    body: patient,
    responseTransformer: async (data: any) => new Patient(data)
  })
  patienten.value![index] = response.data!! as Patient;
};

const cm = ref();
const toast = useToast();
const selectedPatient = ref<Patient | null>(null);

const patientDialog = ref<boolean>(false)
const isDialogCreate = ref<boolean>(true)
const initialDialogData = ref<Patient | null>(null)

const menuModel = ref([
  {label: 'Bearbeiten', key: 'edit', command: onEditPatientContextMenuItemClicked},
  {label: 'Löschen', key: 'delete', command: deleteSelectedPatient},
]);

const onRowContextMenu = (event: DataTableRowContextMenuEvent) => {
  cm.value.show(event.originalEvent);
};

function onEditPatientContextMenuItemClicked() {
  initialDialogData.value = selectedPatient.value
  openPatientDialog(false)
}

function onCreateButtonClicked() {
  initialDialogData.value = null
  openPatientDialog(true)
}

function openPatientDialog(isContextCreate: boolean) {
  patientDialog.value = true
  isDialogCreate.value = isContextCreate
}

async function deleteSelectedPatient() {
  await deletePatient({path: {id: selectedPatient.value!!.id}});

  patienten.value = patienten.value!!.filter((p) =>
      p.id != selectedPatient.value!!.id
  )

  toast.add({severity: 'error', summary: 'Patient Gelöscht', detail: selectedPatient.value!!.getFullName, life: 3000});
  selectedPatient.value = null;
}

</script>

<template>
  <main class="overflow-y-hidden">
    <Card>
      <template #content>
        <Toast></Toast>

        <ContextMenu ref="cm" :model="menuModel" @hide="selectedPatient = null">
          <template #itemicon="{item}">
            <Icon v-if="item.key == 'edit'">edit</Icon>
            <Icon v-if="item.key == 'delete'">delete</Icon>
          </template>
        </ContextMenu>

        <DataTable
            :value="patienten"
            key="id"
            :scrollable="true"
            :resizable-columns="true"
            :column-resize-mode="'fit'"
            :contextMenu="true"
            @row-contextmenu="onRowContextMenu"
            v-model:contextMenuSelection="selectedPatient"
        >
          <template #header>
            <div class="flex flex-row place-content-between items-end">

              <h1 class="text-xl">Patienten</h1>

              <Button
                  label="Neu"
                  :size="'small'"
                  @click="onCreateButtonClicked"
                  outlined
              >
                <template #icon>
                  <Icon :size="24">person_add</Icon>
                </template>
              </Button>
            </div>
          </template>
          <Column
              key="name"
              class="text-base/4 text-nowrap content-start">
            <template #header>
              <Icon>abc</Icon>
              Name
            </template>
            <template #body="{data}:{data: Patient}">
              {{ data.getFullName() }}
            </template>
          </Column>
          <Column
              key="adresse"
              class="text-base/4 text-nowrap content-start">
            <template #header>
              <Icon>pin_drop</Icon>
              Adresse
            </template>
            <template #body="{data} : {data: Patient}">
              <template v-if="data.getAddress()">
                <pre class="font-sans">{{ data.getAddress()!! }}</pre>
              </template>
              <template v-else>
                -
              </template>
            </template>
          </Column>
          <Column
              key="kontakt"
              class="text-base/4 text-nowrap content-start">
            <template #header>
              <Icon>contact_phone</Icon>
              Kontakt
            </template>
            <template #body="{data} : {data: Patient}">
              <div v-if="data.telMobil || data.telFestnetz || data.email" class="flex flex-col gap-2">
                <a v-if="data.telMobil"
                   class="flex flex-row place-items-center gap-1 hover:text-primary"
                   :href="'tel:'+ data.telMobil">
                  <Icon :size="16">smartphone</Icon>
                  {{ data.telMobil }}
                </a>
                <a v-if="data.telFestnetz"
                   class="flex flex-row place-items-center gap-1 hover:text-primary"
                   :href="'tel:' + data.telFestnetz">
                  <Icon :size="16">call</Icon>
                  {{ data.telFestnetz }}
                </a>
                <a v-if="data.email"
                   class="flex flex-row place-items-center gap-1 hover:text-primary"
                   :href="'mailto:' + data.email">
                  <Icon :size="16">mail</Icon>
                  {{ data.email }}
                </a>
              </div>
              <template v-else>
                -
              </template>
            </template>
          </Column>
          <Column
              key="kontakt"
              class="text-base/4 text-nowrap content-start">
            <template #header>
              <Icon>event</Icon>
              Geburtstag
            </template>
            <template #body="{data} : {data: Patient}">
              {{ data.geburtstag ? dateFormat(new Date(data.geburtstag), "dd.mm.yyyy") : '-' }}
            </template>
          </Column>
        </DataTable>

        <Dialog
            v-model:visible="patientDialog"
            :header="isDialogCreate ? 'Patient erstellen' : 'Patient bearbeiten'"
            class="lg"
            :style="{ width: '50vw' }" :breakpoints="{ '63.9375rem': '75vw', '39.9375rem': '90vw' }"
            :modal="true"

        >
          <PatientForm
              :on-submit="onDialogSubmit"
              :initial-patient="initialDialogData"
              :on-cancel="() => patientDialog = false">
          </PatientForm>
        </Dialog>
      </template>
    </Card>


  </main>
</template>

<style scoped>

</style>