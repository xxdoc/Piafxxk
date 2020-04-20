VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "GamePage"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'======================================
'   ҳ�������
    Dim Page As GPage
    Private Type NewNote
        Name As String
        index As Integer
        time As Long
        Direction As Integer
    End Type
    Dim Notes() As NewNote
    Dim ShineTime As Long
    Public Title As String
'======================================
Public Sub Add(index As Integer, Name As String)
    If index = -1 Then Exit Sub
    
    ShineTime = GetTickCount
    
    If index = 99 Then Exit Sub
    If index = 98 Then Exit Sub
    
    ReDim Preserve Notes(UBound(Notes) + 1)
    With Notes(UBound(Notes))
        Randomize
        .Direction = Int(Rnd * 4)
        .index = index
        .Name = Name
        .time = GetTickCount
    End With
End Sub
Public Sub Update()
    '��Ϸÿһ֡�Ĺ��̣����ƹ�������ڴ˴���
    Dim spro As Single
    spro = (GetTickCount - ShineTime) / 300
    If spro > 1 Then spro = 1
    spro = 1 - Cubic(spro, 0, 0, 0, 1)
    
    Page.Clear argb(255, 120 * spro + Abs((GetTickCount Mod 4000) - 2000) / 2000 * 120 * spro, 120 * spro + Abs((GetTickCount Mod 8000) - 4000) / 4000 * 120 * spro, 120 * spro + Abs((GetTickCount Mod 2800) - 1400) / 1400 * 120 * spro) '��ջ���

    '================================================================
    '   ʾ������������
    '   Page.Writes "��������", 20,20, Color:=argb(255, 0, 0, 0)
    '================================================================
    
    Dim pro As Single, w As Long, h As Long
    Dim delMark As Boolean, mode As Integer, opro As Single
    
    For I = 1 To UBound(Notes)
        If I > UBound(Notes) Then Exit For
        pro = (GetTickCount - Notes(I).time) / 400
        delMark = False
        If pro > 1 Then delMark = True: pro = 1
        opro = pro
        If pro < 0.5 Then
            pro = pro / 0.5: mode = 0
        Else
            pro = 1 - (pro - 0.5) / 0.5: mode = 1
        End If
        pro = Cubic(pro, 0, 1, 1, 1)
        
        w = Page.Res.ImgSize(Notes(I).Name & ".gif", imgGetWidth)
        h = Page.Res.ImgSize(Notes(I).Name & ".gif", imgGetHeight)
        
        Page.Paint 0, Notes(I).index / 22 * GW, GH - GH * opro + 1, GW / 22, GH * opro, argb(255 - 255 * opro, 255, 255, 255)
        
        Select Case Notes(I).Direction
            Case 0: Page.DrawImage Notes(I).Name & ".gif", -w / 2 + w * 1 * pro, GH / 2, alpha:=pro, pos:=posOnCenter, Direction:=DirNormal
            Case 1: Page.DrawImage Notes(I).Name & ".gif", GW + w / 2 - w * 1 * pro, GH / 2, alpha:=pro, pos:=posOnCenter, Direction:=DirVertical
            Case 2: Page.DrawImage Notes(I).Name & ".gif", GW / 2, -h / 2 + h * 1 * pro, alpha:=pro, pos:=posOnCenter, Direction:=DirVertical
            Case 3: Page.DrawImage Notes(I).Name & ".gif", GW / 2, GH + h / 2 - h * 1 * pro, alpha:=pro, pos:=posOnCenter, Direction:=DirHorizontalVertical
        End Select
        
        If delMark Then
            Notes(I) = Notes(UBound(Notes))
            I = I - 1
            ReDim Preserve Notes(UBound(Notes) - 1)
        End If
    Next
    
    For I = 1 To UBound(Notes)
        opro = (GetTickCount - Notes(I).time) / 400
        If opro > 1 Then opro = 1
        Page.Paint 0, Notes(I).index / 22 * GW, GH - GH * opro + 1, GW / 22, GH * opro, argb(255 - 255 * opro, 255, 255, 255)
    Next
    
    Page.Writes Title, GW / 2, GH - 100, 36, argb(255, 255, 255, 255), align:=StringAlignmentCenter, style:=FontStyleBold, BorderColor:=argb(255, 0, 0, 0), BorderSize:=2
End Sub
Public Sub Wheel(Direction As Integer, Depth As Single)
    '�������¼�
    'Direction:����Depth�����
End Sub
Public Sub AnimationMsg(id As String, msg As String)
    '������Ϣ����
End Sub
Public Sub Enter()
    'ҳ������¼�
End Sub
Public Sub Leave()
    'ҳ���뿪�¼�
End Sub
Public Sub Gotfocus()
    '����ȡ�ý����¼�
End Sub
Public Sub Lostfocus()
    '����ʧȥ�����¼�
End Sub
Public Sub AnimationDone(id As Integer)
    '�������Ž����¼�
    'id�������Ķ���ID
End Sub
Private Sub Class_Initialize()
    ReDim Notes(0)
    Title = "��Ĺ�������"
    
    '����ҳ�������
    Set Page = New GPage
    Page.Create Me
    '������Ϸ��Դ
    Page.Res.NewImages App.path & "\assets"
    '����ҳ��
    ECore.Add Page, "GamePage"
    
    '===============================================
    '   �����Ҫ���Ӷ�����������ڴ˴�
    
    '===============================================
End Sub