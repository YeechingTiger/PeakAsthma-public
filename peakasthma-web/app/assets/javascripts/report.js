function renderReportChart() {
  Chart.defaults.global.defaultFontSize = 15;
  Chart.defaults.global.defaultFontColor = '#222';
  var ctx = document.getElementById("reportChart").getContext('2d');
  var reportChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: [reportPeriod],
      datasets: [{
          label: 'Green Zone',
          data: [green_count],
          backgroundColor: 'rgba(40, 210, 60, 0.2)',
          borderColor: 'rgba(40, 210, 60, 1)',
          borderWidth: 1
        },
        {
          label: 'Yellow Zone',
          data: [yellow_count],
          backgroundColor: 'rgba(255, 206, 86, 0.2)',
          borderColor: 'rgba(255, 206, 86, 1)',
          borderWidth: 1
        },
        {
          label: 'Red Zone',
          data: [red_count],
          backgroundColor: 'rgba(255, 99, 132, 0.2)',
          borderColor: 'rgba(255,99,132,1)',
          borderWidth: 1
        }
      ]
    },
    options: {
      title: {
        display: true,
        fontSize: 25,
        text: "Asthma Zones"
      },
      scales: {
        xAxes: [{
          gridLines: {
            display: false
          }
        }],
        yAxes: [{
          scaleLabel: {
            display: true,
            labelString: "Number of Days"
          },
          ticks: {
            beginAtZero: true
          }
        }]
      }
    }
  });
}

function downloadPDF() {
  options = {
    scale: 2,
    onclone: async function(clonedDoc) {
      var sidebar_button = clonedDoc.getElementById('sidebar-button');
      sidebar_button.click();
      await sleep(1000);
    }
  };
  html2canvas(document.querySelector('#reportPDF'), options).then(function (canvas) {
    var pdf = new jsPDF('p', 'mm', 'a4');
    pdf.addImage(canvas.toDataURL('image/png'), 'PNG', 0, 0, 211, 298);
    pdf.save(filename + '.pdf');
  });
}

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}
