import { Link } from 'react-router-dom'
import { useGetRezepteQuery } from '../api/rezepteApi'
import { PageHeader } from '@/shared/components/PageHeader'
import { Button } from '@/shared/components/ui/button'
import { Badge } from '@/shared/components/ui/badge'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/shared/components/ui/table'
import { Card, CardContent, CardHeader, CardTitle } from '@/shared/components/ui/card'
import { Upload, Eye, FileText } from 'lucide-react'

export const RezepteListe = () => {
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
        <div className="text-destructive">Fehler beim Laden der Rezepte</div>
      </div>
    )
  }

  const activeRezepte = rezepte?.filter((r) => !r.rechnung) || []
  const completedRezepte = rezepte?.filter((r) => r.rechnung) || []

  return (
    <div>
      <PageHeader
        title="Rezepte"
        description="Verwalten Sie Ihre Rezepte und Verordnungen"
        actions={
          <Button asChild>
            <Link to="/rezepte/upload">
              <Upload className="mr-2 h-4 w-4" />
              Rezept hochladen
            </Link>
          </Button>
        }
      />

      {/* Statistiken */}
      <div className="mb-6 grid gap-4 md:grid-cols-3">
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Aktive Rezepte
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{activeRezepte.length}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Abgeschlossen
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{completedRezepte.length}</div>
          </CardContent>
        </Card>
        <Card>
          <CardHeader className="pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Gesamtwert
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">
              {formatCurrency(rezepte?.reduce((sum, r) => sum + r.preisGesamt, 0) || 0)}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Rezepte Tabelle */}
      <Card>
        <CardHeader>
          <CardTitle className="flex items-center gap-2">
            <FileText className="h-5 w-5" />
            Alle Rezepte
          </CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Patient</TableHead>
                <TableHead>Ausgestellt am</TableHead>
                <TableHead>Behandlungen</TableHead>
                <TableHead>Gesamtpreis</TableHead>
                <TableHead>Status</TableHead>
                <TableHead className="w-[80px]">Aktionen</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {rezepte?.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={6} className="h-24 text-center">
                    Keine Rezepte vorhanden
                  </TableCell>
                </TableRow>
              ) : (
                rezepte?.map((rezept) => (
                  <TableRow key={rezept.id}>
                    <TableCell className="font-medium">
                      {rezept.patient.vorname} {rezept.patient.nachname}
                    </TableCell>
                    <TableCell>{formatDate(rezept.ausgestelltAm)}</TableCell>
                    <TableCell>
                      {rezept.positionen.map((pos) => (
                        <div key={pos.behandlungsart.id} className="text-sm">
                          {pos.anzahl}x {pos.behandlungsart.name}
                        </div>
                      ))}
                    </TableCell>
                    <TableCell>{formatCurrency(rezept.preisGesamt)}</TableCell>
                    <TableCell>
                      <Badge variant={rezept.rechnung ? 'default' : 'secondary'}>
                        {rezept.rechnung ? rezept.rechnung.status : 'Offen'}
                      </Badge>
                    </TableCell>
                    <TableCell>
                      <Button variant="ghost" size="icon-sm" asChild>
                        <Link to={`/rezepte/${rezept.id}`}>
                          <Eye className="h-4 w-4" />
                        </Link>
                      </Button>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )
}
