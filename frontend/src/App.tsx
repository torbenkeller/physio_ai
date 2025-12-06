import { Routes, Route } from 'react-router-dom'
import { Layout } from './shared/components/Layout'
import { Dashboard } from './features/dashboard/components/Dashboard'
import { PatientenListe } from './features/patienten/components/PatientenListe'
import { PatientDetail } from './features/patienten/components/PatientDetail'
import { PatientNeu } from './features/patienten/components/PatientNeu'
import { Kalender } from './features/behandlungen/components/Kalender'
import { RezepteListe } from './features/rezepte/components/RezepteListe'
import { RezeptDetail } from './features/rezepte/components/RezeptDetail'
import { RezeptUpload } from './features/rezepte/components/RezeptUpload'
import { AbrechnungUebersicht } from './features/abrechnung/components/AbrechnungUebersicht'
import { ProfilSeite } from './features/profil/components/ProfilSeite'

const App = () => {
  return (
    <Layout>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        <Route path="/kalender" element={<Kalender />} />
        <Route path="/patienten" element={<PatientenListe />} />
        <Route path="/patienten/neu" element={<PatientNeu />} />
        <Route path="/patienten/:id" element={<PatientDetail />} />
        <Route path="/rezepte" element={<RezepteListe />} />
        <Route path="/rezepte/upload" element={<RezeptUpload />} />
        <Route path="/rezepte/:id" element={<RezeptDetail />} />
        <Route path="/abrechnung" element={<AbrechnungUebersicht />} />
        <Route path="/profil" element={<ProfilSeite />} />
      </Routes>
    </Layout>
  )
}

export default App
