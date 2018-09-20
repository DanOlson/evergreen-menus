export default function (word, count) {
  return Number(count) === 1 ? word : `${word}s`
};
