"""Unmarshall lu XML files."""

import logging
import xml.etree.ElementTree as element_tree
import pyFN.utils.constants as const
import pyFN.unmarshallers.framenet as fn_unmarshaller
from pyFN.models.frame import Frame
from pyFN.models.lexunit import LexUnit

__all__ = ['unmarshall_lexunit_xml']

logger = logging.getLogger(__name__)


def _extract_sentence_tags():
    pass


def unmarshall_lexunit_xml(xml_file_path):
    """Unmarshall a FrameNet lu XML file from file path.

    Return a list of list of AnnotationSet instances extracted from the
    lu XML file. A single list of AnnotationSet instances corresponds
    to all the AnnotationSets of a single Sentence.

    Args
    ----
        param1 xml_files_path: full path to a FrameNet lu XML file.

    """
    logger.info('Unmarshalling FrameNet lu XML file: {}'.format(xml_file_path))
    tree = element_tree.parse(xml_file_path)
    root = tree.getroot()
    frame = Frame(root.get('frame'), _id=int(root.get('frameID')))
    lexunit = LexUnit(frame, _id=int(root.get('ID')), name=root.get('name'))
    subcorpus_tags = root.findall('fn:subCorpus', const.FN_XML_NAMESPACE)
    for subcorpus_tag in subcorpus_tags:
        sentence_tags = subcorpus_tag.findall('fn:sentence',
                                              const.FN_XML_NAMESPACE)
        for sentence_tag in sentence_tags:
            annosets = fn_unmarshaller.extract_fn_annosets_from_sentence_tag(
                sentence_tag, lexunit=lexunit)
            if annosets:
                yield annosets
