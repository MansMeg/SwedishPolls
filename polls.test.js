const fs = require('fs')
const Papa = require('papaparse')

const [header, ...polls] = Papa.parse(fs.readFileSync('Data/Polls.csv', { encoding: 'utf8' })).data.filter((poll) => poll.length > 1)
const newerPolls = polls.slice(1, 100)
const allParties = ['M', 'L', 'C', 'KD', 'S', 'V', 'MP', 'SD', 'FI']

test('Header is correct', () => {
  expect(header.length).toBe(18)
  expect(header).toContain('Company')
  expect(header).toContain('PublDate')
  expect(header).toContain('n')
  expect(header).toContain('collectPeriodFrom')
  expect(header).toContain('collectPeriodTo')
  allParties.forEach((party) => expect(header).toContain(party))
})

const companyIndex = header.indexOf('Company')
const publDateIndex = header.indexOf('PublDate')
const collectFromIndex = header.indexOf('collectPeriodFrom')
const collectToIndex = header.indexOf('collectPeriodTo')

const pollValue = (poll, party) => {
  const index = header.indexOf(party)
  if (index === -1) {
    throw new Error('Failed to find party ' + party)
  }

  if (poll[index] === 'NA') {
    return 0
  }

  return parseFloat(poll[index])
}

test('Contains polls', () => {
  expect(polls.length).toBeGreaterThan(1600)
})

test('Newer poll trends make sense', () => {
  newerPolls.forEach((poll) => {
    const parties = {}
    allParties.forEach((party) => {
      parties[party] = pollValue(poll, party)
    })

    expect(parties['S'], `S in (${poll}) has less than 21% support`).toBeGreaterThan(21)
    expect(parties['S'], `S in (${poll}) has more than 34% support`).toBeLessThan(34)

    expect(parties['V'], `V in (${poll}) has less than 6% support`).toBeGreaterThan(6)
    expect(parties['V'], `V in (${poll}) has more than 12.5% support`).toBeLessThan(12.5)

    expect(parties['MP'], `MP in (${poll}) has less than 2.5% support`).toBeGreaterThan(2.5)
    expect(parties['MP'], `MP in (${poll}) has more than 8% support`).toBeLessThan(8)

    expect(parties['M'], `M in (${poll}) has less than 17% support`).toBeGreaterThan(15)
    expect(parties['M'], `M in (${poll}) has more than 24.5% support`).toBeLessThan(24.6)

    expect(parties['L'], `L in (${poll}) has less than 1.5% support`).toBeGreaterThan(1.5)
    expect(parties['L'], `L in (${poll}) has more than 6% support`).toBeLessThan(6)

    expect(parties['KD'], `KD in (${poll}) has less than 4.0% support`).toBeGreaterThan(3.9)
    expect(parties['KD'], `KD in (${poll}) has more than 13.5% support`).toBeLessThan(13.5)

    expect(parties['C'], `C in (${poll}) has less than 4.5% support`).toBeGreaterThan(4.5)
    expect(parties['C'], `C in (${poll}) has more than 11% support`).toBeLessThan(11)

    expect(parties['SD'], `SD in (${poll}) has less than 15.5% support`).toBeGreaterThan(15.4)
    expect(parties['SD'], `SD in (${poll}) has more than 30% support`).toBeLessThan(30)
  })
})

test('All polls sum between 90% and 100%', () => {
  polls.forEach((poll) => {
    const values = allParties.map((party) => pollValue(poll, party))
    const sum = values.reduce((a, b) => a + b, 0)
    expect(sum, `Poll (${poll}) sums to ${sum}, more than 100%`).toBeLessThanOrEqual(100)
    expect(sum, `Poll (${poll}) sums to ${sum}, less than 90%`).toBeGreaterThan(90)
  })
})

// test('Polls should be ordered by date', () => {
//   polls.forEach((poll) => {
//     const publicationDate = new Date(poll[pollIndex])
//     expect(sum, `Poll (${poll}) sums to ${sum}, more than 100%`).toBeLessThanOrEqual(100)
//     expect(sum, `Poll (${poll}) sums to ${sum}, less than 90%`).toBeGreaterThan(90)
//   })
// })

// test('Collection periods should not be too long', () => {
//   polls.forEach((poll) => {
//     const publicationDate = new Date(poll[pollIndex])
//     expect(sum, `Poll (${poll}) sums to ${sum}, more than 100%`).toBeLessThanOrEqual(100)
//     expect(sum, `Poll (${poll}) sums to ${sum}, less than 90%`).toBeGreaterThan(90)
//   })
// })
