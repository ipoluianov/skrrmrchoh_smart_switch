import React, { useState, useRef, useEffect } from 'react';
import { useDocumentContext } from './DocumentContext';

const ViewSettings: React.FC = () => {
  const { settingsTable, updateSetting } = useDocumentContext();
  const [selectedCell, setSelectedCell] = useState<{ row: number; col: 'Value' | 'Value1' } | null>(null);
  const [isEditing, setIsEditing] = useState(false);
  const [editValue, setEditValue] = useState<string>('');
  const inputRef = useRef<HTMLInputElement>(null);
  const containerRef = useRef<HTMLDivElement>(null);
  const cellRefs = useRef<{ [key: string]: HTMLTableCellElement | null }>({});
  const isNavigating = useRef(false);

  const keys = Object.keys(settingsTable);

  useEffect(() => {
    if (isEditing && inputRef.current) {
      inputRef.current.focus();
    }
  }, [isEditing]);

  useEffect(() => {
    if (selectedCell && isNavigating.current) {
      const cellKey = `${selectedCell.row}-${selectedCell.col}`;
      cellRefs.current[cellKey]?.scrollIntoView({
        block: 'nearest',
        inline: 'nearest',
      });
      isNavigating.current = false;
    }
  }, [selectedCell]);

  const startEditing = (initialValue: string = '') => {
    setIsEditing(true);
    setEditValue(initialValue);
  };

  const finishEditing = () => {
    if (selectedCell) {
      const { row, col } = selectedCell;
      updateSetting(keys[row], col, editValue);
    }
    setIsEditing(false);
    containerRef.current?.focus();
  };

  const handleKeyDown = (event: React.KeyboardEvent) => {
    if (!selectedCell) return;

    const { row, col } = selectedCell;

    if (isEditing) {
      if (event.key === 'Enter') {
        finishEditing();
      } else if (event.key === 'Escape') {
        setIsEditing(false);
        containerRef.current?.focus();
      }
    } else {
      if (event.key === 'ArrowDown' && row < keys.length - 1) {
        event.preventDefault();
        isNavigating.current = true;
        setSelectedCell({ row: row + 1, col });
      } else if (event.key === 'ArrowUp' && row > 0) {
        event.preventDefault();
        isNavigating.current = true;
        setSelectedCell({ row: row - 1, col });
      } else if (event.key === 'ArrowRight' && col === 'Value') {
        event.preventDefault();
        isNavigating.current = true;
        setSelectedCell({ row, col: 'Value1' });
      } else if (event.key === 'ArrowLeft' && col === 'Value1') {
        event.preventDefault();
        isNavigating.current = true;
        setSelectedCell({ row, col: 'Value' });
      } else if (event.key === 'Enter') {
        startEditing(settingsTable[keys[row]][col]);
      } else if (/^[a-zA-Z0-9]$/.test(event.key)) {
        event.preventDefault();
        startEditing(event.key);
      }
    }
  };

  return (
    <div
      ref={containerRef}
      style={{
        height: '80vh',
        overflowX: 'auto', // Горизонтальный скроллинг, если содержимое выходит за пределы
        overflowY: 'auto', // Вертикальный скроллинг
        border: '1px solid #ddd',
        borderRadius: '4px',
        outline: 'none',
      }}
      onKeyDown={handleKeyDown}
      tabIndex={0}
    >
      <table style={{ borderCollapse: 'collapse', width: 'auto' }}> {/* Устанавливаем ширину таблицы на auto */}
        <thead style={{ position: 'sticky', top: 0, backgroundColor: '#f9f9f9', zIndex: 1 }}>
          <tr>
            <th style={{ width: '200px', padding: '8px', borderBottom: '1px solid #ccc', borderRight: '1px solid #ccc' }}>Key</th>
            <th style={{ width: '200px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc', borderRight: '1px solid #ccc' }}>Value</th>
            <th style={{ width: '200px', padding: '8px', borderBottom: '1px solid #ccc', borderLeft: '1px solid #ccc' }}>Value1</th>
          </tr>
        </thead>
        <tbody>
          {keys.map((key, rowIndex) => (
            <tr key={key}>
              <td
                style={{
                  width: '200px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderRight: '1px solid #ccc',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-Key`] = el)}
              >
                {key}
              </td>
              <td
                style={{
                  width: '200px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  borderRight: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 'Value' ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-Value`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 'Value' });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 'Value' && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => setEditValue(e.target.value)}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  settingsTable[key].Value
                )}
              </td>
              <td
                style={{
                  width: '200px',
                  padding: '8px',
                  borderBottom: '1px solid #ccc',
                  borderLeft: '1px solid #ccc',
                  backgroundColor: selectedCell?.row === rowIndex && selectedCell.col === 'Value1' ? '#d3d3d3' : 'transparent',
                }}
                ref={(el) => (cellRefs.current[`${rowIndex}-Value1`] = el)}
                onClick={() => {
                  setSelectedCell({ row: rowIndex, col: 'Value1' });
                  setIsEditing(false);
                }}
              >
                {selectedCell?.row === rowIndex && selectedCell.col === 'Value1' && isEditing ? (
                  <input
                    ref={inputRef}
                    type="text"
                    value={editValue}
                    onChange={(e) => setEditValue(e.target.value)}
                    onBlur={() => finishEditing()}
                  />
                ) : (
                  settingsTable[key].Value1
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ViewSettings;
