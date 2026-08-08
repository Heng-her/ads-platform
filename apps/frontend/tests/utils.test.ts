import { describe, expect, it } from 'vitest'
import { getArticleUrl, slugify } from '~/lib/utils'

describe('article URLs', () => {
  it('keeps Khmer characters in article slugs', () => {
    expect(slugify('នេះជាអក្សរខ្មែរ')).toBe('នេះជាអក្សរខ្មែរ')
  })

  it('includes Khmer titles in the article URL before the UUID', () => {
    expect(getArticleUrl({
      id: 'ed13dbae-bc69-466e-87a1-435d0da0f141',
      title: 'នេះជាអក្សរខ្មែរ',
    })).toBe('/article/នេះជាអក្សរខ្មែរ-ed13dbae-bc69-466e-87a1-435d0da0f141')
  })
})
