import { afterEach, describe, expect, it, vi } from 'vitest';
import getHandler from '@/server/api/billboards/index.get';
import { nowPlayingResponseMock } from '@/server/api/billboards/__mocks__/now-playing-response-mock';
import { movieGenresResponseMock } from '../__mocks__/genres-response-mock';

const fetchMock = vi.fn((url) => {
  if (url.includes('movie/now_playing')) return nowPlayingResponseMock

  if (url.includes('genre/movie/list')) return movieGenresResponseMock

  return null
})

vi.stubGlobal('$fetch', fetchMock);

describe('Event handler: GET /billboards', () => {
  afterEach(() => {
    vi.clearAllMocks();
  })

  it('should return an array of parsed movies', async () => {
    const response = await getHandler({} as any);

    expect(response).toEqual(expect.objectContaining({
      movies: expect.arrayContaining([
        expect.objectContaining({
          title: expect.any(String),
          genres: expect.arrayContaining([expect.any(String)]),
          backdropPath: expect.any(String),
          posterPath: expect.any(String),
        })
      ])
    }));
  })

  it('should set genre as empty string if genre not found', async () => {
    fetchMock.mockImplementation((url) => {
      if (url.includes('movie/now_playing')) return nowPlayingResponseMock
  
      if (url.includes('genre/movie/list')) return { genres: [] }
  
      return null
    })

    const response = await getHandler({} as any);

    expect(response).toEqual(expect.objectContaining({
      movies: expect.arrayContaining([
        expect.objectContaining({
          genres: expect.arrayContaining(['']),
        })
      ])
    }));
  })
})
