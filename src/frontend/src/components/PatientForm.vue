<script setup lang="ts">
import type {Patient} from "./models.ts";
import {Form} from '@primevue/forms'
import {reactive} from "vue";
import {Button, DatePicker, Divider, FloatLabel, InputText} from "primevue";
import type {FormResolverOptions, FormSubmitEvent} from "@primevue/forms/form";
import {v4 as uuidv4} from 'uuid';
import dateFormat from "dateformat";

interface OnSubmitCallback {
  (patient: Patient): void
}

interface OnCancelCallback {
  (): void
}

const props = defineProps<{
  initialPatient: Patient | null,
  onSubmit: OnSubmitCallback,
  onCancel: OnCancelCallback,
}>();

const initialValues = reactive({
  patientTitel: props.initialPatient?.titel ?? '',
  patientVorname: props.initialPatient?.vorname ?? '',
  patientNachname: props.initialPatient?.nachname ?? '',
  strasse: props.initialPatient?.strasse ?? '',
  hausnummer: props.initialPatient?.hausnummer ?? '',
  plz: props.initialPatient?.plz ?? '',
  stadt: props.initialPatient?.stadt ?? '',
  telMobil: props.initialPatient?.telMobil ?? '',
  telFestnetz: props.initialPatient?.telFestnetz ?? '',
  email: props.initialPatient?.email ?? '',
  geburtstag: props.initialPatient?.geburtstag ? new Date(props.initialPatient?.geburtstag) : null,
});

const onFormSubmit = ({valid, states}: FormSubmitEvent) => {
  if (!valid) {
    return;
  }

  let updatedPatient = props.initialPatient ?? <Patient>{id: uuidv4()};

  updatedPatient.titel = states.patientTitel.value
  updatedPatient.vorname = states.patientVorname.value
  updatedPatient.nachname = states.patientNachname.value
  updatedPatient.strasse = states.strasse.value
  updatedPatient.hausnummer = states.hausnummer.value
  updatedPatient.plz = states.plz.value
  updatedPatient.stadt = states.stadt.value
  updatedPatient.telMobil = states.telMobil.value
  updatedPatient.telFestnetz = states.telFestnetz.value
  updatedPatient.email = states.email.value
  updatedPatient.geburtstag = dateFormat(states.geburtstag.value as Date, 'yyyy-mm-dd')

  props.onSubmit(updatedPatient)
};

const resolver = ({values}: FormResolverOptions): Record<string, any> => {
  const errors = <Record<string, any>>{};

  if (!values.patientName) {
    errors.patientName = [{message: 'Name muss gesetzt sein'}];
  }

  return {
    errors
  };
};


</script>

<template>
  <Form
      v-slot="$form"
      :resolver
      :initial-values="initialValues"
      @submit="onFormSubmit"
      class="flex flex-col gap-4"
  >

    <div class="flex flex-row place-content-stretch gap-4">
      <FloatLabel variant="in" class="grow">
        <label for="patientTitelInput">Titel</label>
        <InputText id="patientTitelInput" name="patientTitel" type="text" autocomplete="false"
                   class="w-full"></InputText>
      </FloatLabel>

      <FloatLabel variant="in" class="grow">
        <label for="patientVornameInput">Vorname</label>
        <InputText id="patientVornameInput" name="patientVorname" type="text" autocomplete="false"
                   class="w-full"></InputText>
      </FloatLabel>
      <FloatLabel variant="in" class="grow">
        <label for="patientNachnameInput">Nachname</label>
        <InputText id="patientNachnameInput" name="patientNachname" type="text" autocomplete="false"
                   class="w-full"></InputText>
      </FloatLabel>


    </div>
    <FloatLabel variant="in" class="grow">
      <label for="patientGeburtstagInput">Geburtstag</label>
      <DatePicker id="patientGeburtstagInput" name="geburtstag" type="date" class="w-full"></DatePicker>
    </FloatLabel>

    <divider class="col-span-2 h-2"></divider>

    <div class="flex flex-row place-content-stretch gap-4">
      <FloatLabel variant="in" class="grow">
        <label for="patientStrasseInput">Straße</label>
        <InputText id="patientStrasseInput" name="strasse" type="text" class="w-full"></InputText>
      </FloatLabel>

      <FloatLabel variant="in" class="w-32">
        <label for="patientHausnummerInput">Hausnummer</label>
        <InputText id="patientHausnummerInput" name="hausnummer" type="text" class="w-full"></InputText>
      </FloatLabel>
    </div>

    <div class="flex flex-row place-content-stretch gap-4">

      <FloatLabel variant="in" class="grow">
        <label for="patientPlzInput">PLZ</label>
        <InputText id="patientPlzInput" name="plz" type="text" class="w-full"></InputText>
      </FloatLabel>

      <FloatLabel variant="in" class="grow">
        <label for="patientStadtInput">Stadt</label>
        <InputText id="patientStadtInput" name="stadt" type="text" class="w-full"></InputText>
      </FloatLabel>
    </div>

    <divider class="col-span-2"></divider>

    <FloatLabel variant="in" class="grow">
      <label for="patientEmailInput">E-Mail</label>
      <InputText id="patientEmailInput" name="email" type="text" class="w-full"></InputText>
    </FloatLabel>

    <FloatLabel variant="in" class="grow">
      <label for="patientTelMobilInput">Tel. (Mobil)</label>
      <InputText id="patientTelMobilInput" name="telMobil" type="text" class="w-full"></InputText>
    </FloatLabel>

    <FloatLabel variant="in" class="grow">
      <label for="patientTelFestnetzInput">Tel. (Festnetz)</label>
      <InputText id="patientTelFestnetzInput" name="telFestnetz" type="text" class="w-full"></InputText>
    </FloatLabel>

    <div class="flex justify-end gap-2">
      <Button type="button" label="Cancel" severity="secondary" @click="props.onCancel()"></Button>
      <Button type="submit" label="Save"></Button>
    </div>
  </Form>
</template>

<style scoped>

</style>