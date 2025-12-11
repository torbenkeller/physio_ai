import { useState, useEffect } from 'react'
import {
  useGetProfileQuery,
  useUpdateProfileMutation,
  useCreateProfileMutation,
} from '../api/profileApi'
import { PageHeader } from '@/shared/components/PageHeader'
import { Button } from '@/shared/components/ui/button'
import { Input } from '@/shared/components/ui/input'
import { Label } from '@/shared/components/ui/label'
import {
  Card,
  CardContent,
  CardHeader,
  CardTitle,
  CardDescription,
} from '@/shared/components/ui/card'
import { Separator } from '@/shared/components/ui/separator'
import {
  Building2,
  User,
  Link as LinkIcon,
  Save,
  Copy,
  Check,
  CalendarDays,
  Calendar,
} from 'lucide-react'
import { toast } from 'sonner'

export const ProfilSeite = () => {
  const { data: profile, isLoading, error } = useGetProfileQuery()
  const [updateProfile, { isLoading: isUpdating }] = useUpdateProfileMutation()
  const [createProfile, { isLoading: isCreating }] = useCreateProfileMutation()

  const [praxisName, setPraxisName] = useState(profile?.praxisName || '')
  const [inhaberName, setInhaberName] = useState(profile?.inhaberName || '')
  const [defaultBehandlungenProRezept, setDefaultBehandlungenProRezept] = useState(
    profile?.defaultBehandlungenProRezept ?? 8
  )
  const [externalCalendarUrl, setExternalCalendarUrl] = useState(profile?.externalCalendarUrl || '')
  const [copied, setCopied] = useState(false)

  // Update state when profile loads
  useEffect(() => {
    if (profile) {
      setPraxisName(profile.praxisName)
      setInhaberName(profile.inhaberName)
      setDefaultBehandlungenProRezept(profile.defaultBehandlungenProRezept)
      setExternalCalendarUrl(profile.externalCalendarUrl || '')
    }
  }, [profile])

  const handleSave = async () => {
    try {
      if (profile) {
        await updateProfile({
          praxisName,
          inhaberName,
          defaultBehandlungenProRezept,
          externalCalendarUrl: externalCalendarUrl || null,
        }).unwrap()
      } else {
        await createProfile({ praxisName, inhaberName, defaultBehandlungenProRezept }).unwrap()
      }
      toast.success('Profil erfolgreich gespeichert')
    } catch {
      toast.error('Fehler beim Speichern des Profils')
    }
  }

  const handleCopyCalendarUrl = async () => {
    if (!profile?.calenderUrl) return
    try {
      await navigator.clipboard.writeText(profile.calenderUrl)
      setCopied(true)
      toast.success('Kalender-URL kopiert')
      setTimeout(() => setCopied(false), 2000)
    } catch {
      toast.error('Fehler beim Kopieren')
    }
  }

  if (isLoading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-muted-foreground">Laden...</div>
      </div>
    )
  }

  if (error && 'status' in error && error.status !== 404) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-destructive">Fehler beim Laden des Profils</div>
      </div>
    )
  }

  return (
    <div>
      <PageHeader title="Profil" description="Verwalten Sie Ihre Praxiseinstellungen" />

      <div className="grid gap-6 lg:grid-cols-2">
        {/* Praxisdaten */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Building2 className="h-5 w-5" />
              Praxisdaten
            </CardTitle>
            <CardDescription>
              Diese Daten werden für Rechnungen und Dokumente verwendet
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="praxisName">Praxisname</Label>
              <Input
                id="praxisName"
                value={praxisName}
                onChange={(e) => setPraxisName(e.target.value)}
                placeholder="z.B. Physiotherapie Mustermann"
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="inhaberName">Inhaber</Label>
              <div className="flex items-center gap-2">
                <User className="h-4 w-4 text-muted-foreground" />
                <Input
                  id="inhaberName"
                  value={inhaberName}
                  onChange={(e) => setInhaberName(e.target.value)}
                  placeholder="z.B. Max Mustermann"
                />
              </div>
            </div>
            <Button onClick={handleSave} disabled={isUpdating || isCreating}>
              <Save className="mr-2 h-4 w-4" />
              {isUpdating || isCreating ? 'Speichern...' : 'Speichern'}
            </Button>
          </CardContent>
        </Card>

        {/* Kalender-Integration */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <LinkIcon className="h-5 w-5" />
              Kalender-Integration
            </CardTitle>
            <CardDescription>
              Abonnieren Sie Ihren Terminkalender in externen Kalender-Apps
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            {profile?.calenderUrl ? (
              <>
                <div className="space-y-2">
                  <Label>iCal Kalender-URL</Label>
                  <div className="flex gap-2">
                    <Input
                      value={profile.calenderUrl}
                      readOnly
                      className="flex-1 font-mono text-sm"
                    />
                    <Button variant="outline" size="icon" onClick={handleCopyCalendarUrl}>
                      {copied ? (
                        <Check className="h-4 w-4 text-green-500" />
                      ) : (
                        <Copy className="h-4 w-4" />
                      )}
                    </Button>
                  </div>
                </div>

                <Separator />

                <div className="space-y-2">
                  <h4 className="font-medium">So fügen Sie den Kalender hinzu:</h4>
                  <ul className="list-inside list-disc space-y-1 text-sm text-muted-foreground">
                    <li>
                      <strong>Apple Kalender:</strong> Ablage → Neues Kalenderabonnement → URL
                      einfügen
                    </li>
                    <li>
                      <strong>Google Kalender:</strong> Einstellungen → Kalender hinzufügen → Per
                      URL
                    </li>
                    <li>
                      <strong>Outlook:</strong> Kalender → Kalender hinzufügen → Aus dem Internet
                    </li>
                  </ul>
                </div>
              </>
            ) : (
              <p className="text-muted-foreground">
                Speichern Sie zuerst Ihre Praxisdaten, um die Kalender-URL zu erhalten.
              </p>
            )}
          </CardContent>
        </Card>

        {/* Behandlungs-Einstellungen */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <CalendarDays className="h-5 w-5" />
              Behandlungs-Einstellungen
            </CardTitle>
            <CardDescription>Standard-Einstellungen für Behandlungstermine</CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="defaultBehandlungenProRezept">Standard Behandlungen pro Rezept</Label>
              <Input
                id="defaultBehandlungenProRezept"
                type="number"
                min={1}
                max={20}
                value={defaultBehandlungenProRezept}
                onChange={(e) => setDefaultBehandlungenProRezept(Number(e.target.value))}
              />
              <p className="text-sm text-muted-foreground">
                Diese Anzahl wird als Vorschlag bei der Erstellung mehrerer Termine verwendet.
              </p>
            </div>
            <Button onClick={handleSave} disabled={isUpdating || isCreating}>
              <Save className="mr-2 h-4 w-4" />
              {isUpdating || isCreating ? 'Speichern...' : 'Speichern'}
            </Button>
          </CardContent>
        </Card>

        {/* Externer Kalender */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Calendar className="h-5 w-5" />
              Externer Kalender
            </CardTitle>
            <CardDescription>
              Importieren Sie Termine aus einem externen Kalender (z.B. iCloud, Google)
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="space-y-2">
              <Label htmlFor="externalCalendarUrl">iCal-URL</Label>
              <Input
                id="externalCalendarUrl"
                value={externalCalendarUrl}
                onChange={(e) => setExternalCalendarUrl(e.target.value)}
                placeholder="https://calendar.google.com/... oder webcal://..."
              />
              <p className="text-sm text-muted-foreground">
                Private Termine werden im Kalender angezeigt, um Doppelbuchungen zu vermeiden.
              </p>
            </div>

            <Separator />

            <div className="space-y-2">
              <h4 className="font-medium">So finden Sie die Kalender-URL:</h4>
              <ul className="list-inside list-disc space-y-1 text-sm text-muted-foreground">
                <li>
                  <strong>iCloud:</strong> Kalender teilen (öffentlich) und Link kopieren
                </li>
                <li>
                  <strong>Google:</strong> Kalender-Einstellungen → Geheime Adresse im iCal-Format
                </li>
                <li>
                  <strong>Outlook:</strong> Kalender → Kalender freigeben → ICS Link
                </li>
              </ul>
            </div>

            <Button onClick={handleSave} disabled={isUpdating || isCreating}>
              <Save className="mr-2 h-4 w-4" />
              {isUpdating || isCreating ? 'Speichern...' : 'Speichern'}
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
