


def main() {

    sh '''
        mkdir -p tables
    '''

    def files = []
    dir('signs') {
        files = sh (
            script: """
                ls
            """,
            returnStdout: true
        )
    }

    files.tokenize().each {
        sh '''
            awk -F"," '{print $1,$2,$3,$4,$5,$8}' signs/${it} > tables/${it}2.csv
            awk '{print $1 "," $2 "," $3 "," $4 "," $5 "," $8}' tables/${it}2.csv > tables/${it}.csv
            rm tables/${it}2.csv
        '''
    }

}


main()
