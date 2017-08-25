"""FrameNet LexUnit class."""

import pyFN.utils.framenet as fn_utils

__all__ = ['LexUnit']


class LexUnit():
    """FrameNet LexUnit class."""

    def __init__(self, frame, _id=None, name=None):
        """Constructor."""
        self.__id = _id
        self._name = name
        self._pos = fn_utils.extract_pos(self._name)
        self._frame = frame


    @property
    def _id(self):
        """Return the lexunit ID."""
        return self.__id

    @property
    def name(self):
        """Return the lexunit name."""
        return self._name

    @property
    def pos(self):
        """Return the part of speech (POS) of the lexical unit."""
        return self._pos

    @property
    def frame(self):
        """Return the frame object corresponding to the lexunit."""
        return self._frame

    @_id.setter
    def _id(self, _id):
        self.__id = _id

    @name.setter
    def name(self, name):
        self._name = name
