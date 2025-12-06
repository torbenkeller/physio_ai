import { Link } from 'react-router-dom'
import { useGetRezepteQuery } from '@/features/rezepte/api/rezepteApi'
import { PageHeader } from '@/shared/components/PageHeader'
import { Button } from '@/shared/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/shared/components/ui/card'
import { Badge } from '@/shared/components/ui/badge'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/shared/components/ui/table'
import { Eye, CheckCircle, Clock, AlertCircle } from 'lucide-react'
import { RezeptRechnungStatus } from '@/features/rezepte/types/rezept.types'

export const AbrechnungUebersicht = () => {
  const { data: rezepte, isLoading, error } = useGetRezepteQuery()

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('de-DE')
  }

  const formatCurrency = (amount: number) => {
    return new Intl.NumberFormat('de-DE', {
      style: 'currency',
      currency: 'EUR',
    }).format(amount)
  }

  if (isLoading) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-muted-foreground">Laden...</div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-destructive">Fehler beim Laden der Abrechnungsdaten</div>
      </div>
    )
  }

  // Gruppiere Rezepte nach Status
  const offeneRezepte = rezepte?.filter((r) => !r.rechnung) || []
  const rechnungGestellt = rezepte?.filter(
    (r) => r.rechnung?.status === RezeptRechnungStatus.OFFEN
  ) || []
  const bezahlteRezepte = rezepte?.filter(
    (r) => r.rechnung?.status === RezeptRechnungStatus.BEZAHLT
  ) || []

  // Berechne Summen
  const offenerBetrag = offeneRezepte.reduce((sum, r) => sum + r.preisGesamt, 0)
  const ausstehendeZahlungen = rechnungGestellt.reduce((sum, r) => sum + r.preisGesamt, 0)
  const bezahlteBetrag = bezahlteRezepte.reduce((sum, r) => sum + r.preisGesamt, 0)

  const getStatusBadge = (status: RezeptRechnungStatus | null) => {
    if (!status) {
      return (
        <Badge variant="secondary" className="gap-1">
          <Clock className="h-3 w-3" />
          Offen
        </Badge>
      )
    }
    switch (status) {
      case RezeptRechnungStatus.OFFEN:
        return (
          <Badge variant="outline" className="gap-1 border-yellow-500 text-yellow-600">
            <AlertCircle className="h-3 w-3" />
            Rechnung gestellt
          </Badge>
        )
      case RezeptRechnungStatus.BEZAHLT:
        return (
          <Badge variant="default" className="gap-1 bg-green-500">
            <CheckCircle className="h-3 w-3" />
            Bezahlt
          </Badge>
        )
      default:
        return <Badge variant="secondary">{status}</Badge>
    }
  }

  return (
    <div>
      <PageHeader
        title="Abrechnung"
        description="Übersicht Ihrer offenen und abgeschlossenen Abrechnungen"
      />

      {/* Statistik-Karten */}
      <div className="mb-6 grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="flex items-center gap-2 text-sm font-medium text-muted-foreground">
              <Clock className="h-4 w-4" />
              Noch abzurechnen
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{formatCurrency(offenerBetrag)}</div>
            <p className="text-sm text-muted-foreground">{offeneRezepte.length} Rezepte</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="flex items-center gap-2 text-sm font-medium text-muted-foreground">
              <AlertCircle className="h-4 w-4 text-yellow-500" />
              Ausstehende Zahlungen
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-yellow-600">
              {formatCurrency(ausstehendeZahlungen)}
            </div>
            <p className="text-sm text-muted-foreground">{rechnungGestellt.length} Rechnungen</p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="flex items-center gap-2 text-sm font-medium text-muted-foreground">
              <CheckCircle className="h-4 w-4 text-green-500" />
              Bezahlt (Gesamt)
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold text-green-600">
              {formatCurrency(bezahlteBetrag)}
            </div>
            <p className="text-sm text-muted-foreground">{bezahlteRezepte.length} Rezepte</p>
          </CardContent>
        </Card>
      </div>

      {/* Offene Rezepte */}
      {offeneRezepte.length > 0 && (
        <Card className="mb-6">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Clock className="h-5 w-5" />
              Noch abzurechnen
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Patient</TableHead>
                  <TableHead>Ausgestellt</TableHead>
                  <TableHead>Behandlungen</TableHead>
                  <TableHead className="text-right">Betrag</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="w-[80px]">Aktionen</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {offeneRezepte.map((rezept) => (
                  <TableRow key={rezept.id}>
                    <TableCell className="font-medium">
                      {rezept.patient.vorname} {rezept.patient.nachname}
                    </TableCell>
                    <TableCell>{formatDate(rezept.ausgestelltAm)}</TableCell>
                    <TableCell>
                      {rezept.positionen.reduce((sum, pos) => sum + pos.anzahl, 0)} Behandlungen
                    </TableCell>
                    <TableCell className="text-right font-medium">
                      {formatCurrency(rezept.preisGesamt)}
                    </TableCell>
                    <TableCell>{getStatusBadge(null)}</TableCell>
                    <TableCell>
                      <Button variant="ghost" size="icon-sm" asChild>
                        <Link to={`/rezepte/${rezept.id}`}>
                          <Eye className="h-4 w-4" />
                        </Link>
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      )}

      {/* Ausstehende Zahlungen */}
      {rechnungGestellt.length > 0 && (
        <Card className="mb-6">
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-yellow-600">
              <AlertCircle className="h-5 w-5" />
              Ausstehende Zahlungen
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Patient</TableHead>
                  <TableHead>Rechnungsnummer</TableHead>
                  <TableHead className="text-right">Betrag</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="w-[80px]">Aktionen</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {rechnungGestellt.map((rezept) => (
                  <TableRow key={rezept.id}>
                    <TableCell className="font-medium">
                      {rezept.patient.vorname} {rezept.patient.nachname}
                    </TableCell>
                    <TableCell>{rezept.rechnung?.rechnungsnummer}</TableCell>
                    <TableCell className="text-right font-medium">
                      {formatCurrency(rezept.preisGesamt)}
                    </TableCell>
                    <TableCell>{getStatusBadge(rezept.rechnung?.status || null)}</TableCell>
                    <TableCell>
                      <Button variant="ghost" size="icon-sm" asChild>
                        <Link to={`/rezepte/${rezept.id}`}>
                          <Eye className="h-4 w-4" />
                        </Link>
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      )}

      {/* Bezahlte Rezepte */}
      {bezahlteRezepte.length > 0 && (
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2 text-green-600">
              <CheckCircle className="h-5 w-5" />
              Bezahlt
            </CardTitle>
          </CardHeader>
          <CardContent>
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Patient</TableHead>
                  <TableHead>Rechnungsnummer</TableHead>
                  <TableHead className="text-right">Betrag</TableHead>
                  <TableHead>Status</TableHead>
                  <TableHead className="w-[80px]">Aktionen</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {bezahlteRezepte.map((rezept) => (
                  <TableRow key={rezept.id}>
                    <TableCell className="font-medium">
                      {rezept.patient.vorname} {rezept.patient.nachname}
                    </TableCell>
                    <TableCell>{rezept.rechnung?.rechnungsnummer}</TableCell>
                    <TableCell className="text-right font-medium">
                      {formatCurrency(rezept.preisGesamt)}
                    </TableCell>
                    <TableCell>{getStatusBadge(rezept.rechnung?.status || null)}</TableCell>
                    <TableCell>
                      <Button variant="ghost" size="icon-sm" asChild>
                        <Link to={`/rezepte/${rezept.id}`}>
                          <Eye className="h-4 w-4" />
                        </Link>
                      </Button>
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </CardContent>
        </Card>
      )}

      {rezepte?.length === 0 && (
        <Card>
          <CardContent className="flex h-32 items-center justify-center">
            <p className="text-muted-foreground">Keine Rezepte zur Abrechnung vorhanden</p>
          </CardContent>
        </Card>
      )}
    </div>
  )
}
