import { Link } from 'react-router-dom'
import { useGetWeeklyCalendarQuery } from '@/features/behandlungen/api/behandlungenApi'
import { useGetRezepteQuery } from '@/features/rezepte/api/rezepteApi'
import { useGetPatientenQuery } from '@/features/patienten/api/patientenApi'
import { PageHeader } from '@/shared/components/PageHeader'
import { Card, CardContent, CardHeader, CardTitle } from '@/shared/components/ui/card'
import { Button } from '@/shared/components/ui/button'
import {
  Users,
  Calendar,
  FileText,
  Clock,
  ArrowRight,
  TrendingUp,
} from 'lucide-react'

const formatDateForApi = (date: Date) => {
  return date.toISOString().split('T')[0]
}

export const Dashboard = () => {
  const today = new Date()
  const dateStr = formatDateForApi(today)

  const { data: calendarData } = useGetWeeklyCalendarQuery(dateStr)
  const { data: rezepte } = useGetRezepteQuery()
  const { data: patienten } = useGetPatientenQuery()

  // Heute Termine
  const heuteTermine = calendarData?.[dateStr] || []

  // Offene Rezepte (ohne Rechnung)
  const offeneRezepte = rezepte?.filter((r) => !r.rechnung) || []

  // Gesamtwert offener Rezepte
  const offenerGesamtwert = offeneRezepte.reduce((sum, r) => sum + r.preisGesamt, 0)

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('de-DE', {
      style: 'currency',
      currency: 'EUR',
    }).format(amount)
  }

  const formatTime = (dateString: string) => {
    return new Date(dateString).toLocaleTimeString('de-DE', {
      hour: '2-digit',
      minute: '2-digit',
    })
  }

  return (
    <div>
      <PageHeader
        title="Dashboard"
        description={`Willkommen zurück! Heute ist ${today.toLocaleDateString('de-DE', {
          weekday: 'long',
          day: 'numeric',
          month: 'long',
          year: 'numeric',
        })}`}
      />

      {/* Statistik-Karten */}
      <div className="mb-8 grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Termine heute
            </CardTitle>
            <Calendar className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{heuteTermine.length}</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Patienten gesamt
            </CardTitle>
            <Users className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{patienten?.length || 0}</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Offene Rezepte
            </CardTitle>
            <FileText className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{offeneRezepte.length}</div>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Offener Betrag
            </CardTitle>
            <TrendingUp className="h-4 w-4 text-muted-foreground" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{formatCurrency(offenerGesamtwert)}</div>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        {/* Heutige Termine */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="flex items-center gap-2">
              <Clock className="h-5 w-5" />
              Heutige Termine
            </CardTitle>
            <Button variant="ghost" size="sm" asChild>
              <Link to="/kalender">
                Zum Kalender
                <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
          </CardHeader>
          <CardContent>
            {heuteTermine.length === 0 ? (
              <p className="text-muted-foreground">Keine Termine für heute</p>
            ) : (
              <div className="space-y-3">
                {heuteTermine.map((termin) => (
                  <div
                    key={termin.id}
                    className="flex items-center justify-between rounded-lg border p-3"
                  >
                    <div>
                      <p className="font-medium">{termin.patient.name}</p>
                      <p className="text-sm text-muted-foreground">
                        {formatTime(termin.startZeit)} - {formatTime(termin.endZeit)}
                      </p>
                    </div>
                    <Button variant="outline" size="sm" asChild>
                      <Link to={`/patienten/${termin.patient.id}`}>
                        Details
                      </Link>
                    </Button>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

        {/* Offene Rezepte */}
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="flex items-center gap-2">
              <FileText className="h-5 w-5" />
              Offene Rezepte
            </CardTitle>
            <Button variant="ghost" size="sm" asChild>
              <Link to="/abrechnung">
                Zur Abrechnung
                <ArrowRight className="ml-2 h-4 w-4" />
              </Link>
            </Button>
          </CardHeader>
          <CardContent>
            {offeneRezepte.length === 0 ? (
              <p className="text-muted-foreground">Keine offenen Rezepte</p>
            ) : (
              <div className="space-y-3">
                {offeneRezepte.slice(0, 5).map((rezept) => (
                  <div
                    key={rezept.id}
                    className="flex items-center justify-between rounded-lg border p-3"
                  >
                    <div>
                      <p className="font-medium">
                        {rezept.patient.vorname} {rezept.patient.nachname}
                      </p>
                      <p className="text-sm text-muted-foreground">
                        {rezept.positionen.reduce((sum, pos) => sum + pos.anzahl, 0)} Behandlungen
                      </p>
                    </div>
                    <div className="text-right">
                      <p className="font-medium">{formatCurrency(rezept.preisGesamt)}</p>
                      <Button variant="outline" size="sm" asChild className="mt-1">
                        <Link to={`/rezepte/${rezept.id}`}>
                          Details
                        </Link>
                      </Button>
                    </div>
                  </div>
                ))}
                {offeneRezepte.length > 5 && (
                  <p className="text-center text-sm text-muted-foreground">
                    + {offeneRezepte.length - 5} weitere Rezepte
                  </p>
                )}
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
