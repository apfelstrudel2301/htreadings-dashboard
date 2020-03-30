import datetime
import dash
import dash_core_components as dcc
import dash_html_components as html
import plotly
import pymysql as pymysql
from dash.dependencies import Input, Output
from pyathena import connect
import os


RDS_ENDPOINT = os.environ.get('RDS_ENDPOINT')
DB_NAME = os.environ.get('DB_NAME')
DB_USERNAME = os.environ.get('DB_USERNAME')

last_n_values = 200
last_n_minutes = 0
external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']

app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
# Beanstalk looks for application by default, if this isn't set you will get a WSGI error.
application = app.server

app.layout = html.Div(
    html.Div([
        html.H4('Indoor Temperature and Humidity'),
        html.Div(id='live-update-text'),
        dcc.Graph(id='live-update-graph'),
        dcc.Interval(
            id='interval-component',
            interval=30 * 1000,  # in milliseconds
            n_intervals=0
        )
    ])
)


@app.callback(Output('live-update-text', 'children'),
              [Input('interval-component', 'n_intervals')])
def update_metrics(n):
    timestamps, temperatures, humidities = get_latest_values(n_values=1, s3=False)
    timestamp = timestamps[0]
    temperature = temperatures[0]
    humidity = humidities[0]
    style = {'padding': '5px', 'fontSize': '16px'}
    return [
        html.Span('Timestamp data: {}'.format(timestamp), style=style),
        html.Span('Temperature: {0:.2f}'.format(temperature), style=style),
        html.Span('Humidity: {0:.2f}'.format(humidity), style=style),
        html.Span('Timestamp last dashboard update: {}'.format(datetime.datetime.now()), style=style),
    ]


# Multiple components can update everytime interval gets fired.
@app.callback(Output('live-update-graph', 'figure'),
              [Input('interval-component', 'n_intervals')])
def update_graph_live(n):
    data = {
        'time': [],
        'temperature': [],
        'humidity': []
    }
    timestamps, temperatures, humidities = get_latest_values(s3=False)
    data['temperature'] = temperatures
    data['time'] = timestamps
    data['humidity'] = humidities

    # Create the graph with subplots
    fig = plotly.subplots.make_subplots(rows=1, cols=1, vertical_spacing=0.2)
    fig['layout']['margin'] = {
        'l': 30, 'r': 10, 'b': 30, 't': 10
    }
    fig['layout']['legend'] = {'x': 0, 'y': 1, 'xanchor': 'left'}

    fig.append_trace({
        'x': data['time'],
        'y': data['temperature'],
        'name': 'Temperature',
        'text': data['temperature'],
        'mode': 'lines+markers',
        'type': 'scatter'
    }, 1, 1)
    fig.append_trace({
        'x': data['time'],
        'y': data['humidity'],
        'name': 'Humidity',
        'text': data['humidity'],
        'mode': 'lines+markers',
        'type': 'scatter'
    }, 1, 1)

    return fig


def get_latest_values(n_values=last_n_values, n_minutes=last_n_minutes, s3=False):
    if s3:
        conn = connect(s3_staging_dir='s3://athena-results-htreadings/',
                           region_name='eu-central-1')
        table_name = 'sensordata.htreadings'
    else:
        password = 'adminadmin'
        table_name = 'htreadings'
        conn = pymysql.connect(RDS_ENDPOINT, user=DB_USERNAME, passwd=password, db=DB_NAME, connect_timeout=5)
    cur = conn.cursor()
    if n_values > 0:
        cur.execute("SELECT distinct timestamp, temperature, humidity FROM {} order by timestamp "
                    "desc limit {}".format(table_name, n_values))
    elif n_minutes > 0:
        from_time = datetime.datetime.now() - datetime.timedelta(seconds=n_minutes * 60)
        cur.execute("SELECT distinct timestamp, temperature, humidity FROM sensordata.htreadings order by timestamp "
                    "desc where timestamp > {}".format(from_time))
    else:
        ValueError('last_n_values < 0 and last_n_minutes < 0')
    rows = cur.fetchall()
    conn.close()
    timestamps = list(map(lambda x: x[0], rows))
    temperatures = list(map(lambda x: x[1], rows))
    humidities = list(map(lambda x: x[2], rows))
    return timestamps, temperatures, humidities


if __name__ == '__main__':
    app.run_server(debug=True, port=8080)
