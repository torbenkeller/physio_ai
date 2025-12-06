import { useParams, useNavigate, Link } from 'react-router-dom'
import { useGetRezeptQuery } from '../api/rezepteApi'
import { PageHeader } from '@/shared/components/PageHeader'
import { Button } from '@/shared/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/shared/components/ui/card'
import { Badge } from '@/shared/components/ui/badge'
import { Separator } from '@/shared/components/ui/separator'
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from '@/shared/components/ui/table'
import { ArrowLeft, User, Calendar, Stethoscope } from 'lucide-react'

export const RezeptDetail = () => {
  const { id } = useParams<{ id: string }>()
  const navigate = useNavigate()
  const { data: rezept, isLoading, error } = useGetRezeptQuery(id!)

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

  if (error || !rezept) {
    return (
      <div className="flex h-64 items-center justify-center">
        <div className="text-destructive">Rezept nicht gefunden</div>
      </div>
    )
  }

  return (
    <div>
      <PageHeader
        title={`Rezept für ${rezept.patient.vorname} ${rezept.patient.nachname}`}
        description={`Ausgestellt am ${formatDate(rezept.ausgestelltAm)}`}
        actions={
          <Button variant="outline" onClick={() => navigate('/rezepte')}>
            <ArrowLeft className="mr-2 h-4 w-4" />
            Zurück
          </Button>
        }
      />

      <div className="grid gap-6 md:grid-cols-3">
        {/* Patient Info */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <User className="h-5 w-5" />
              Patient
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              <div>
                <span className="text-muted-foreground">Name:</span>
                <Link
                  to={`/patienten/${rezept.patient.id}`}
                  className="ml-2 text-primary hover:underline"
                >
                  {rezept.patient.titel && `${rezept.patient.titel} `}
                  {rezept.patient.vorname} {rezept.patient.nachname}
                </Link>
              </div>
              {rezept.patient.geburtstag && (
                <div>
                  <span className="text-muted-foreground">Geburtsdatum:</span>
                  <span className="ml-2">{formatDate(rezept.patient.geburtstag)}</span>
                </div>
              )}
            </div>
          </CardContent>
        </Card>

        {/* Rezept Info */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Calendar className="h-5 w-5" />
              Rezept Details
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              <div>
                <span className="text-muted-foreground">Ausgestellt:</span>
                <span className="ml-2">{formatDate(rezept.ausgestelltAm)}</span>
              </div>
              {rezept.ausgestelltVon && (
                <div>
                  <span className="text-muted-foreground">Von:</span>
                  <span className="ml-2">{rezept.ausgestelltVon.name}</span>
                </div>
              )}
              <div>
                <span className="text-muted-foreground">Status:</span>
                <Badge variant={rezept.rechnung ? 'default' : 'secondary'} className="ml-2">
                  {rezept.rechnung ? rezept.rechnung.status : 'Offen'}
                </Badge>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Preis Info */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Stethoscope className="h-5 w-5" />
              Abrechnung
            </CardTitle>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              <div className="text-3xl font-bold">
                {formatCurrency(rezept.preisGesamt)}
              </div>
              <div className="text-sm text-muted-foreground">
                {rezept.positionen.reduce((sum, pos) => sum + pos.anzahl, 0)} Behandlungen gesamt
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <Separator className="my-6" />

      {/* Behandlungen */}
      <Card>
        <CardHeader>
          <CardTitle>Verordnete Behandlungen</CardTitle>
        </CardHeader>
        <CardContent>
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Behandlungsart</TableHead>
                <TableHead className="text-right">Anzahl</TableHead>
                <TableHead className="text-right">Einzelpreis</TableHead>
                <TableHead className="text-right">Gesamt</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {rezept.positionen.map((position, index) => (
                <TableRow key={index}>
                  <TableCell className="font-medium">
                    {position.behandlungsart.name}
                  </TableCell>
                  <TableCell className="text-right">{position.anzahl}</TableCell>
                  <TableCell className="text-right">
                    {formatCurrency(position.behandlungsart.preis)}
                  </TableCell>
                  <TableCell className="text-right">
                    {formatCurrency(position.behandlungsart.preis * position.anzahl)}
                  </TableCell>
                </TableRow>
              ))}
              <TableRow>
                <TableCell colSpan={3} className="text-right font-bold">
                  Gesamtbetrag:
                </TableCell>
                <TableCell className="text-right font-bold">
                  {formatCurrency(rezept.preisGesamt)}
                </TableCell>
              </TableRow>
            </TableBody>
          </Table>
        </CardContent>
      </Card>
    </div>
  )
}
