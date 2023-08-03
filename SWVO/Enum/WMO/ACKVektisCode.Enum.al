/// <summary>
/// Enum ACKVektisCode
/// </summary>
enum 50000 ACKVektisCode implements ACKWMOIProcessor
{
    Extensible = true;
    Caption = 'Vektis code', Locked = true;
    DefaultImplementation = ACKWMOIProcessor = ACKWMOProcessorDefault;

    value(414; wmo301)
    {
        Caption = '301', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor301;
    }
    value(415; wmo302)
    {
        Caption = '302', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor302;
    }
    value(418; wmo305)
    {
        Caption = '305', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor305;
    }
    value(419; wmo306)
    {
        Caption = '306', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor306;
    }
    value(420; wmo307)
    {
        Caption = '307', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor307;
    }
    value(421; wmo308)
    {
        Caption = '308', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor308;
    }
    value(444; wmo315)
    {
        Caption = '315', Locked = true;
    }
    value(445; wmo316)
    {
        Caption = '316', Locked = true;
    }
    value(470; wmo401)
    {
        Caption = '401', Locked = true;
    }
    value(471; wmo402)
    {
        Caption = '402', Locked = true;
    }
    value(472; wmo403)
    {
        Caption = '403', Locked = true;
    }
    value(473; wmo404)
    {
        Caption = '404', Locked = true;
    }
    value(480; wmo317)
    {
        Caption = '317', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor317;
    }
    value(481; wmo318)
    {
        Caption = '318', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor318;
    }
    value(482; wmo319)
    {
        Caption = '319', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor319;
    }
    value(483; wmo320)
    {
        Caption = '320', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor320;
    }
    value(484; wmo323)
    {
        Caption = '323', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor323;
    }
    value(485; wmo325)
    {
        Caption = '325', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor325;
    }
    value(486; StudentTransport)
    {
        Caption = 'StudentTransport', Locked = true;
        Implementation = ACKWMOIProcessor = ACKWMOProcessor325;
    }

}